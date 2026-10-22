import { describe, expect, test } from "bun:test";
import { run, type Deps } from "./codeberg.ts";

const API = "https://codeberg.org/api/v1";

type Reply = { status: number; body: unknown };

type Sent = { method: string; url: string; body: unknown; auth: string };

const pr = {
  number: 99,
  title: "Original title",
  state: "open",
  head: { ref: "feature", label: "feature" },
  base: { ref: "main" },
  merged: false,
  labels: [{ id: 1, name: "feat", description: "Features" }],
  html_url: "https://codeberg.org/test/repo/pulls/99",
  body: "Original body",
};

const labels = [
  { id: 1, name: "feat", description: "Features" },
  { id: 2, name: "refa", description: "Refactoring" },
];

const hook = {
  id: 10,
  type: "gitea",
  active: true,
  created_at: "2026-01-01T12:00:00Z",
  updated_at: "2026-10-01T12:00:00Z",
  config: {
    url: "https://ci.example.com/hook",
    secret: "fake-hook-secret",
    authorization_header: "fake-hook-authorization",
  },
  events: ["push", "pull_request"],
};

const page = "limit=50&page=1";

const reviewer = (login: string, fullName: string) => ({
  login,
  full_name: fullName,
  email: `${login}@noreply.codeberg.org`,
});

const review = (
  user: ReturnType<typeof reviewer>,
  state: string,
  official: boolean,
  dismissed: boolean,
) => ({ user, state, official, dismissed });

const alice = reviewer("alice", "Alice Doe");
const bob = reviewer("bob", "");
const carol = reviewer("carol", "Carol");
const dave = reviewer("dave", "Dave");
const erin = reviewer("erin", "Erin");

const reviews = [
  review(alice, "APPROVED", true, false),
  review(bob, "APPROVED", true, false),
  review(carol, "APPROVED", true, false),
  review(carol, "REQUEST_CHANGES", true, false),
  review(dave, "APPROVED", false, false),
  review(erin, "APPROVED", true, true),
];

const routes: Record<string, Reply> = {
  [`GET ${API}/repos/test/repo`]: {
    status: 200,
    body: { default_branch: "main", default_delete_branch_after_merge: true },
  },
  [`GET ${API}/repos/test/repo/labels?${page}`]: { status: 200, body: labels },
  [`GET ${API}/repos/test/repo/hooks?${page}`]: { status: 200, body: [hook] },
  [`GET ${API}/repos/test/repo/pulls/99`]: { status: 200, body: pr },
  [`GET ${API}/repos/test/repo/pulls?${page}`]: { status: 200, body: [pr] },
  [`GET ${API}/repos/test/repo/pulls?state=open&${page}`]: {
    status: 200,
    body: [pr, { ...pr, number: 100, head: { ref: "other", label: "other" } }],
  },
  [`GET ${API}/repos/test/repo/pulls/3`]: {
    status: 200,
    body: {
      ...pr,
      number: 3,
      state: "closed",
      merged: true,
      head: { ref: "refs/pull/3/head", label: "old-feature" },
    },
  },
  [`GET ${API}/repos/test/repo/pulls/99/reviews?${page}`]: {
    status: 200,
    body: reviews,
  },
  [`POST ${API}/repos/test/repo/pulls/99/merge`]: {
    status: 200,
    body: undefined,
  },
  [`GET ${API}/forbidden`]: { status: 403, body: { message: "Forbidden" } },
  [`POST ${API}/repos/test/repo/pulls`]: {
    status: 201,
    body: { ...pr, title: "New title", body: "New body" },
  },
  [`PATCH ${API}/repos/test/repo/pulls/99`]: {
    status: 200,
    body: { ...pr, title: "Edited title", body: "New body" },
  },
  [`PUT ${API}/repos/test/repo/issues/99/labels`]: {
    status: 200,
    body: [labels[1]],
  },
  [`DELETE ${API}/resource`]: { status: 204, body: undefined },
  [`DELETE ${API}/repos/test/repo/hooks/10`]: { status: 204, body: undefined },
  [`DELETE ${API}/repos/test/repo/hooks/11`]: {
    status: 403,
    body: { message: "Forbidden" },
  },
};

const parse = (raw: string): unknown => {
  try {
    const parsed: unknown = JSON.parse(raw);
    return parsed;
  } catch (error: unknown) {
    throw new Error(`invalid JSON: ${raw}`, { cause: error });
  }
};

const parseSent = (body: RequestInit["body"]): unknown =>
  typeof body === "string" ? parse(body) : undefined;

const authOf = (init: RequestInit): string => {
  const headers = new Headers(init.headers);
  const auth = headers.get("Authorization");
  if (auth === null) throw new Error("missing Authorization header");
  return auth;
};

const methodOf = (init: RequestInit): string => {
  if (init.method === undefined) throw new Error("missing method");
  return init.method;
};

const replyOf = (reply: Reply): Response => {
  const body = reply.body === undefined ? null : JSON.stringify(reply.body);
  return new Response(body, { status: reply.status });
};

const gitValues: Record<string, string> = {
  "remote get-url origin": "ssh://git@codeberg.org/test/repo.git",
  "branch --show-current": "feature",
};

const setup = (overrides: Partial<Deps>) => {
  const sent: Sent[] = [];
  const logs: string[] = [];
  const deps: Deps = {
    fetch: (url, init) => {
      const method = methodOf(init);
      sent.push({
        method,
        url,
        body: parseSent(init.body),
        auth: authOf(init),
      });
      const reply = routes[`${method} ${url}`];
      if (reply === undefined) throw new Error(`unexpected ${method} ${url}`);
      const response = replyOf(reply);
      return Promise.resolve(response);
    },
    git: (args) => {
      const command = args.join(" ");
      const value = gitValues[command];
      if (value === undefined) throw new Error(`unexpected git ${command}`);
      return Promise.resolve(value);
    },
    token: "fake-test-key",
    readFile: (path) => Promise.resolve(`file ${path}`),
    readStdin: () => Promise.resolve("New body"),
    log: (line) => {
      logs.push(line);
    },
    ...overrides,
  };
  return { deps, sent, logs };
};

const failure = async (argv: string[], deps: Deps): Promise<string> => {
  try {
    await run(argv, deps);
  } catch (error: unknown) {
    return error instanceof Error ? error.message : String(error);
  }
  throw new Error("expected a failure");
};

const json = async (argv: string[], deps: Deps): Promise<unknown> => {
  const output = await run([...argv, "--json"], deps);
  return parse(output);
};

describe("codeberg", () => {
  test("pr list returns summaries", async () => {
    const { deps } = setup({});
    const listed = await json(["pr", "list", "--repo", "test/repo"], deps);
    expect(listed).toEqual([
      {
        number: 99,
        title: "Original title",
        state: "open",
        head: "feature",
        base: "main",
        labels: ["feat"],
        url: "https://codeberg.org/test/repo/pulls/99",
      },
    ]);
  });

  test("pr list encodes state", async () => {
    const { deps, sent } = setup({});
    await run(["pr", "list", "--state", "open"], deps);
    expect(sent[0]?.url).toBe(
      `${API}/repos/test/repo/pulls?state=open&${page}`,
    );
  });

  test("pr view prints text with body", async () => {
    const { deps, logs } = setup({});
    const viewed = await run(["pr", "view", "99"], deps);
    const expected = [
      "number: 99",
      "title: Original title",
      "state: open",
      "head: feature",
      "base: main",
      "labels: feat",
      "url: https://codeberg.org/test/repo/pulls/99",
      "body: Original body",
    ].join("\n");
    expect(viewed).toBe(expected);
    expect(logs).toEqual([]);
  });

  test("pr view shows merged PRs by branch name", async () => {
    const { deps } = setup({});
    const viewed = await json(["pr", "view", "3"], deps);
    expect(viewed).toMatchObject({ state: "merged", head: "old-feature" });
  });

  test("pr view resolves the current branch PR", async () => {
    const { deps, sent } = setup({});
    const viewed = await json(["pr", "view"], deps);
    expect(viewed).toMatchObject({ number: 99 });
    const urls = sent.map((request) => request.url);
    expect(urls).toEqual([
      `${API}/repos/test/repo/pulls?state=open&${page}`,
      `${API}/repos/test/repo/pulls/99`,
    ]);
  });

  test("pr view fails without a matching open PR", async () => {
    const { deps } = setup({ git: () => Promise.resolve("missing") });
    const message = await failure(["pr", "view", "--repo", "test/repo"], deps);
    expect(message).toBe(
      "resolve current pr: expected one open PR for branch 'missing', found 0; pass its number",
    );
  });

  test("labels lists every label", async () => {
    const { deps } = setup({});
    const listed = await run(["labels"], deps);
    const expected = [
      "id: 1\nname: feat\ndescription: Features",
      "id: 2\nname: refa\ndescription: Refactoring",
    ].join("\n\n");
    expect(listed).toBe(expected);
  });

  test("labels follows pagination", async () => {
    const full = Array.from({ length: 50 }, (_, id) => ({
      id,
      name: `label-${id}`,
      description: "",
    }));
    const { deps } = setup({
      fetch: (url) => {
        const body = url.endsWith("page=1") ? full : [labels[0]];
        const response = Response.json(body);
        return Promise.resolve(response);
      },
    });
    const listed = await json(["labels"], deps);
    expect(listed).toHaveLength(51);
  });

  test("webhooks detects the repository and prints safe fields", async () => {
    const { deps, sent } = setup({});
    const output = await run(["webhooks"], deps);
    const expected = [
      "id: 10",
      "type: gitea",
      "active: true",
      "created_at: 2026-01-01T12:00:00Z",
      "updated_at: 2026-10-01T12:00:00Z",
      "url: https://ci.example.com/hook",
      "events: push, pull_request",
    ].join("\n");
    expect(output).toBe(expected);
    expect(sent[0]?.url).toBe(`${API}/repos/test/repo/hooks?${page}`);
  });

  test("webhooks JSON and verbose logs exclude secret fields", async () => {
    const { deps, logs } = setup({});
    const output = await run(["webhooks", "--json", "--verbose"], deps);
    const parsed = parse(output);
    expect(parsed).toEqual([
      {
        id: 10,
        type: "gitea",
        active: true,
        created_at: "2026-01-01T12:00:00Z",
        updated_at: "2026-10-01T12:00:00Z",
        url: "https://ci.example.com/hook",
        events: ["push", "pull_request"],
      },
    ]);
    const rendered = [output, ...logs].join("\n");
    expect(rendered).not.toContain("fake-hook-secret");
    expect(rendered).not.toContain("fake-hook-authorization");
    expect(rendered).not.toContain("fake-test-key");
  });

  test("webhooks honors an explicit repository without git", async () => {
    const { deps } = setup({
      git: () => Promise.reject(new Error("unexpected git")),
    });
    const listed = await json(["webhooks", "--repo", "test/repo"], deps);
    expect(listed).toHaveLength(1);
  });

  test("webhooks follows pagination and includes inactive hooks", async () => {
    const full = Array.from({ length: 50 }, (_, id) => ({ ...hook, id }));
    const urls: string[] = [];
    const { deps } = setup({
      fetch: (url) => {
        urls.push(url);
        const body = url.endsWith("page=1")
          ? full
          : [{ ...hook, id: 50, active: false }];
        const response = Response.json(body);
        return Promise.resolve(response);
      },
    });
    const listed = await json(["webhooks"], deps);
    expect(listed).toHaveLength(51);
    expect(listed).toContainEqual({
      id: 50,
      type: "gitea",
      active: false,
      created_at: "2026-01-01T12:00:00Z",
      updated_at: "2026-10-01T12:00:00Z",
      url: "https://ci.example.com/hook",
      events: ["push", "pull_request"],
    });
    expect(urls).toEqual([
      `${API}/repos/test/repo/hooks?limit=50&page=1`,
      `${API}/repos/test/repo/hooks?limit=50&page=2`,
    ]);
  });

  test("webhooks strips URL credentials and query parameters", async () => {
    const body = [
      {
        ...hook,
        config: {
          url: "https://fake-user:fake-password@ci.example.com/hook?token=fake-query#fake-fragment",
        },
      },
    ];
    const response = Response.json(body);
    const { deps } = setup({ fetch: () => Promise.resolve(response) });
    const listed = await json(["webhooks"], deps);
    const expected = [{ url: "https://ci.example.com/hook" }];
    expect(listed).toMatchObject(expected);
  });

  test("webhooks returns an empty JSON list when none exist", async () => {
    const response = Response.json([]);
    const { deps } = setup({ fetch: () => Promise.resolve(response) });
    const listed = await json(["webhooks"], deps);
    expect(listed).toEqual([]);
  });

  test("webhooks rejects malformed events", async () => {
    const body = [{ ...hook, events: [42] }];
    const response = Response.json(body);
    const { deps } = setup({ fetch: () => Promise.resolve(response) });
    const message = await failure(["webhooks"], deps);
    expect(message).toBe("expected webhook event to be a string");
  });

  test("webhooks delete removes only the requested hook", async () => {
    const { deps, sent } = setup({});
    const deleted = await json(["webhooks", "delete", "10"], deps);
    expect(deleted).toEqual({ id: 10, repo: "test/repo", state: "deleted" });
    expect(sent).toHaveLength(1);
    expect(sent[0]).toMatchObject({
      method: "DELETE",
      url: `${API}/repos/test/repo/hooks/10`,
      body: undefined,
    });
  });

  test("webhooks delete supports an explicit repository", async () => {
    const { deps } = setup({
      git: () => Promise.reject(new Error("unexpected git")),
    });
    const output = await run(
      ["webhooks", "delete", "10", "--repo", "test/repo"],
      deps,
    );
    expect(output).toBe("id: 10\nrepo: test/repo\nstate: deleted");
  });

  test("webhooks delete requires an ID before requesting anything", async () => {
    const { deps, sent } = setup({});
    const message = await failure(["webhooks", "delete"], deps);
    expect(message).toBe("missing <id>");
    expect(sent).toEqual([]);
  });

  test.each(["0", "1.5", "invalid", "9007199254740992"])(
    "webhooks delete rejects ID %s",
    async (id) => {
      const { deps, sent } = setup({});
      const message = await failure(["webhooks", "delete", id], deps);
      expect(message).toBe(`expected a webhook ID, got '${id}'`);
      expect(sent).toEqual([]);
    },
  );

  test("webhooks delete reports API failures", async () => {
    const { deps } = setup({});
    const message = await failure(["webhooks", "delete", "11"], deps);
    expect(message).toBe(
      'request: Codeberg returned HTTP 403 for DELETE repos/test/repo/hooks/11: {"message":"Forbidden"}',
    );
  });

  test("webhooks delete help does not send a request", async () => {
    const { deps, sent } = setup({});
    const output = await run(["webhooks", "delete", "--help"], deps);
    expect(output).toStartWith("codeberg webhooks delete <id>");
    expect(output).toContain("--repo");
    expect(sent).toEqual([]);
  });

  test("pr create resolves head, base and label", async () => {
    const { deps, sent } = setup({});
    const created = await json(
      ["pr", "create", "New title", "--body-file", "-", "--label", "feat"],
      deps,
    );
    expect(created).toMatchObject({ title: "New title", labels: ["feat"] });
    expect(sent.at(-1)?.body).toEqual({
      title: "New title",
      head: "feature",
      base: "main",
      body: "New body",
      labels: [1],
    });
  });

  test("pr create requires a label", async () => {
    const { deps } = setup({});
    const message = await failure(
      ["pr", "create", "New title", "--body-file", "body.md"],
      deps,
    );
    expect(message).toBe("--label is required");
  });

  test("pr create fails on a missing label", async () => {
    const { deps } = setup({});
    const message = await failure(
      ["pr", "create", "Title", "--body-file", "-", "--label", "missing"],
      deps,
    );
    expect(message).toBe(
      "resolve label: label 'missing' does not exist in test/repo",
    );
  });

  test("pr edit patches fields and replaces labels", async () => {
    const { deps, sent } = setup({});
    const argv = ["pr", "edit", "99", "--title", "Edited title"];
    const edited = await json(
      [...argv, "--body-file", "-", "--label", "refa"],
      deps,
    );
    expect(edited).toMatchObject({ title: "Edited title", labels: ["refa"] });
    const patch = sent.find((request) => request.method === "PATCH");
    expect(patch?.body).toEqual({ title: "Edited title", body: "New body" });
    expect(sent.at(-1)?.body).toEqual({ labels: [2] });
  });

  test("pr edit with only a label reads the PR", async () => {
    const { deps, sent } = setup({});
    const edited = await json(["pr", "edit", "99", "--label", "refa"], deps);
    expect(edited).toMatchObject({ title: "Original title", labels: ["refa"] });
    const patched = sent.some((request) => request.method === "PATCH");
    expect(patched).toBe(false);
  });

  test("pr edit reads the body from a file", async () => {
    const { deps, sent } = setup({});
    await run(["pr", "edit", "99", "--body-file", "body.md"], deps);
    expect(sent[0]?.body).toEqual({ body: "file body.md" });
  });

  test("pr edit requires a change", async () => {
    const { deps } = setup({});
    const message = await failure(["pr", "edit", "99"], deps);
    expect(message).toBe(
      "pass at least one of --title, --body-file or --label",
    );
  });

  test("pr merge squashes with the same message as the web UI", async () => {
    const { deps, sent } = setup({});
    const merged = await json(["pr", "merge", "99"], deps);
    expect(merged).toMatchObject({ number: 99 });
    const merge = sent.find((request) => request.method === "POST");
    expect(merge?.url).toBe(`${API}/repos/test/repo/pulls/99/merge`);
    expect(merge?.body).toEqual({
      Do: "squash",
      MergeTitleField: "Original title (#99)",
      MergeMessageField: [
        "Reviewed-on: https://codeberg.org/test/repo/pulls/99",
        "Reviewed-by: Alice Doe <alice@noreply.codeberg.org>",
        "Reviewed-by: bob <bob@noreply.codeberg.org>",
      ].join("\n"),
      delete_branch_after_merge: true,
    });
  });

  test("pr merge resolves the current branch PR", async () => {
    const { deps, sent } = setup({});
    await run(["pr", "merge"], deps);
    const merge = sent.find((request) => request.method === "POST");
    expect(merge?.url).toBe(`${API}/repos/test/repo/pulls/99/merge`);
  });

  test("api posts a JSON body by default", async () => {
    const body = JSON.stringify({ title: "New title" });
    const { deps, sent } = setup({ readFile: () => Promise.resolve(body) });
    const posted = await run(
      ["api", "repos/test/repo/pulls", "--body-file", "body.json"],
      deps,
    );
    const parsed = parse(posted);
    expect(parsed).toMatchObject({ title: "New title" });
    expect(sent[0]).toMatchObject({
      method: "POST",
      auth: "token fake-test-key",
    });
  });

  test("api prints nothing for an empty response", async () => {
    const { deps } = setup({});
    const output = await run(["api", "resource", "--method", "delete"], deps);
    expect(output).toBe("");
  });

  test("api rejects unsupported methods", async () => {
    const { deps } = setup({});
    const message = await failure(
      ["api", "resource", "--method", "OPTIONS"],
      deps,
    );
    expect(message).toBe("supported methods: GET, POST, PATCH, PUT, DELETE");
  });

  test("api rejects GET with a body", async () => {
    const { deps } = setup({ readStdin: () => Promise.resolve("{}") });
    const message = await failure(
      ["api", "resource", "--method", "GET", "--body-file", "-"],
      deps,
    );
    expect(message).toBe("request: GET requests cannot have a body");
  });

  test("api names the step for an invalid JSON body", async () => {
    const { deps } = setup({});
    const message = await failure(
      ["api", "resource", "--body-file", "-"],
      deps,
    );
    expect(message).toStartWith("parse JSON body: ");
  });

  test("HTTP errors name the method and endpoint", async () => {
    const { deps } = setup({});
    const message = await failure(["api", "forbidden"], deps);
    expect(message).toBe(
      'request: Codeberg returned HTTP 403 for GET forbidden: {"message":"Forbidden"}',
    );
  });

  test("a missing token fails before any request", async () => {
    const { deps, sent } = setup({ token: undefined });
    const message = await failure(["labels"], deps);
    expect(message).toBe("request: CODEBERG_TOKEN is required");
    expect(sent).toEqual([]);
  });

  test("invalid repositories are rejected", async () => {
    const { deps } = setup({});
    const message = await failure(["labels", "--repo", "invalid"], deps);
    expect(message).toBe(
      "resolve repository: expected owner/repo, got 'invalid'",
    );
  });

  test.each([
    "git@codeberg.org:test/repo.git",
    "https://codeberg.org/test/repo",
    "ssh://git@codeberg.org/test/repo",
    "ssh://codeberg.org/test/repo.git",
  ])("origin %s resolves the repository", async (origin) => {
    const { deps, sent } = setup({ git: () => Promise.resolve(origin) });
    await run(["labels"], deps);
    expect(sent[0]?.url).toBe(`${API}/repos/test/repo/labels?${page}`);
  });

  test("verbose logs steps without the token", async () => {
    const { deps, logs } = setup({});
    await run(["labels", "--verbose"], deps);
    expect(logs.length).toBeGreaterThan(0);
    const logged = logs.join("\n");
    expect(logged).not.toContain("fake-test-key");
  });

  test("help lists every flag of a command", async () => {
    const { deps } = setup({});
    const help = await run(["pr", "create", "--help"], deps);
    const flags = ["body-file", "label", "repo", "base", "head", "json"];
    [...flags, "verbose"].forEach((flag) => {
      expect(help).toContain(`--${flag}`);
    });
  });

  test("unknown commands fail with usage", async () => {
    const { deps } = setup({});
    const message = await failure(["pr", "close"], deps);
    expect(message).toStartWith("unknown command 'pr close'");
  });
});
