#!/usr/bin/env bun
import { parseArgs } from "node:util";
import { log } from "./lib/log.ts";
import { output } from "./lib/output.ts";

type Method = "GET" | "POST" | "PATCH" | "PUT" | "DELETE";

const API = "https://codeberg.org/api/v1";
const PAGE_SIZE = 50;
const METHODS: Method[] = ["GET", "POST", "PATCH", "PUT", "DELETE"];
const ORIGIN =
  /^(?:ssh:\/\/(?:git@)?codeberg\.org\/|git@codeberg\.org:|https:\/\/codeberg\.org\/)(?<slug>[^/]+\/[^/]+?)(?:\.git)?$/;
const SLUG = /^[\w.-]+\/[\w.-]+$/;

export type Deps = {
  fetch: (url: string, init: RequestInit) => Promise<Response>;
  git: (args: string[]) => Promise<string>;
  token: string | undefined;
  readFile: (path: string) => Promise<string>;
  readStdin: () => Promise<string>;
  log: (line: string) => void;
};

type Context = { deps: Deps; verbose: boolean };

type Values = Record<string, unknown>;

type Options = {
  repo: string | undefined;
  state: string | undefined;
  title: string | undefined;
  bodyFile: string | undefined;
  label: string | undefined;
  base: string | undefined;
  head: string | undefined;
  method: string | undefined;
  json: boolean;
  verbose: boolean;
  help: boolean;
};

type Input = { positionals: string[]; options: Options };

type Flag = { type: "string" | "boolean"; description: string };

type Command = {
  name: string;
  usage: string;
  positionals: number;
  flags: Record<string, Flag>;
  run: (context: Context, input: Input) => Promise<string>;
};

type Field = string | number | boolean | string[];

type Row = Record<string, Field>;

type Label = { id: number; name: string; description: string };

type Summary = {
  number: number;
  title: string;
  state: string;
  head: string;
  base: string;
  labels: string[];
  url: string;
};

const messageOf = (error: unknown): string =>
  error instanceof Error ? error.message : String(error);

const trace = (
  context: Context,
  name: string,
  attributes: Record<string, unknown>,
): void => {
  if (!context.verbose) return;
  const line = JSON.stringify({ step: name, ...attributes });
  context.deps.log(line);
};

const step = async <T>(
  context: Context,
  name: string,
  attributes: Record<string, unknown>,
  action: () => Promise<T>,
): Promise<T> => {
  trace(context, name, attributes);
  try {
    return await action();
  } catch (error: unknown) {
    throw new Error(`${name}: ${messageOf(error)}`, { cause: error });
  }
};

const isRecord = (value: unknown): value is Record<string, unknown> =>
  typeof value === "object" && value !== null && !Array.isArray(value);

const property = (value: unknown, key: string): unknown => {
  if (!isRecord(value) || !(key in value)) {
    throw new Error(`response is missing '${key}'`);
  }
  return value[key];
};

const text = (value: unknown, key: string): string => {
  const found = property(value, key);
  if (typeof found !== "string") {
    throw new Error(`expected '${key}' to be a string`);
  }
  return found;
};

const integer = (value: unknown, key: string): number => {
  const found = property(value, key);
  if (typeof found !== "number" || !Number.isInteger(found)) {
    throw new Error(`expected '${key}' to be an integer`);
  }
  return found;
};

const boolean = (value: unknown, key: string): boolean => {
  const found = property(value, key);
  if (typeof found !== "boolean") {
    throw new Error(`expected '${key}' to be a boolean`);
  }
  return found;
};

const items = (value: unknown): unknown[] => {
  if (!Array.isArray(value)) {
    throw new Error("expected a list");
  }
  return value;
};

const parseJson = (raw: string, source: string): unknown => {
  try {
    const parsed: unknown = JSON.parse(raw);
    return parsed;
  } catch (error: unknown) {
    throw new Error(`parse ${source}: ${messageOf(error)}`, { cause: error });
  }
};

const toLabel = (value: unknown): Label => ({
  id: integer(value, "id"),
  name: text(value, "name"),
  description: text(value, "description"),
});

const labelNames = (value: unknown): string[] =>
  items(value).map((label) => text(label, "name"));

const webhookEvents = (value: unknown): string[] =>
  items(value).map((event) => {
    if (typeof event !== "string") {
      throw new Error("expected webhook event to be a string");
    }
    return event;
  });

const webhookUrl = (value: string): string => {
  const url = new URL(value);
  return `${url.origin}${url.pathname}`;
};

const toWebhook = (value: unknown): Row => {
  const config = property(value, "config");
  const url = text(config, "url");
  const events = property(value, "events");
  return {
    id: integer(value, "id"),
    type: text(value, "type"),
    active: boolean(value, "active"),
    created_at: text(value, "created_at"),
    updated_at: text(value, "updated_at"),
    url: webhookUrl(url),
    events: webhookEvents(events),
  };
};

const refOf = (pr: unknown, key: string): string => {
  const branch = property(pr, key);
  return text(branch, "ref");
};

const headLabel = (pr: unknown): string => {
  const head = property(pr, "head");
  return text(head, "label");
};

const stateOf = (pr: unknown): string =>
  boolean(pr, "merged") ? "merged" : text(pr, "state");

const toSummary = (pr: unknown): Summary => {
  const labels = property(pr, "labels");
  return {
    number: integer(pr, "number"),
    title: text(pr, "title"),
    state: stateOf(pr),
    head: headLabel(pr),
    base: refOf(pr, "base"),
    labels: labelNames(labels),
    url: text(pr, "html_url"),
  };
};

const renderField = ([key, value]: [string, Field]): string => {
  if (Array.isArray(value)) return `${key}: ${value.join(", ")}`;
  if (typeof value === "string" && value.includes("\n")) {
    return `${key}:\n${value}`;
  }
  return `${key}: ${value}`;
};

const renderRow = (row: Row): string =>
  Object.entries(row).map(renderField).join("\n");

const render = (value: Row | Row[], json: boolean): string => {
  if (json) return JSON.stringify(value, null, 2);
  if (Array.isArray(value)) return value.map(renderRow).join("\n\n");
  return renderRow(value);
};

const isMethod = (value: string): value is Method =>
  METHODS.some((method) => method === value);

const requireToken = (token: string | undefined): string => {
  if (token === undefined || token === "") {
    throw new Error("CODEBERG_TOKEN is required");
  }
  return token;
};

const parseResponse = (raw: string): unknown =>
  raw === "" ? undefined : parseJson(raw, "response");

const urlOf = (endpoint: string): string =>
  `${API}/${endpoint.replace(/^\/+/, "")}`;

const request = (
  context: Context,
  method: Method,
  endpoint: string,
  body: unknown,
): Promise<unknown> =>
  step(context, "request", { method, endpoint }, async () => {
    if (method === "GET" && body !== undefined) {
      throw new Error("GET requests cannot have a body");
    }
    const token = requireToken(context.deps.token);
    const url = urlOf(endpoint);
    const response = await context.deps.fetch(url, {
      method,
      headers: {
        Authorization: `token ${token}`,
        "Content-Type": "application/json",
      },
      body: body === undefined ? null : JSON.stringify(body),
      redirect: "error",
    });
    const raw = await response.text();
    if (!response.ok) {
      throw new Error(
        `Codeberg returned HTTP ${response.status} for ${method} ${endpoint}: ${raw.trim()}`,
      );
    }
    return parseResponse(raw);
  });

const get = (context: Context, endpoint: string): Promise<unknown> =>
  request(context, "GET", endpoint, undefined);

const pageOf = (endpoint: string, page: number): string =>
  `${endpoint}${endpoint.includes("?") ? "&" : "?"}limit=${PAGE_SIZE}&page=${page}`;

const getAll = async (
  context: Context,
  endpoint: string,
  page: number,
): Promise<unknown[]> => {
  const paged = pageOf(endpoint, page);
  const response = await get(context, paged);
  const found = items(response);
  if (found.length < PAGE_SIZE) return found;
  const rest = await getAll(context, endpoint, page + 1);
  return [...found, ...rest];
};

const listAll = (context: Context, endpoint: string): Promise<unknown[]> =>
  getAll(context, endpoint, 1);

const validSlug = (slug: string): string => {
  if (!SLUG.test(slug)) {
    throw new Error(`expected owner/repo, got '${slug}'`);
  }
  return slug;
};

const originSlug = async (context: Context): Promise<string> => {
  const url = await context.deps.git(["remote", "get-url", "origin"]);
  const slug = ORIGIN.exec(url)?.groups?.["slug"];
  if (slug === undefined) {
    throw new Error(`origin '${url}' is not a Codeberg repository`);
  }
  return slug;
};

const repository = (
  context: Context,
  requested: string | undefined,
): Promise<string> =>
  step(context, "resolve repository", { requested }, async () => {
    const slug = requested ?? (await originSlug(context));
    return validSlug(slug);
  });

const currentBranch = (context: Context): Promise<string> =>
  step(context, "resolve current branch", {}, async () => {
    const branch = await context.deps.git(["branch", "--show-current"]);
    if (branch === "") throw new Error("HEAD is detached");
    return branch;
  });

const defaultBranch = (context: Context, slug: string): Promise<string> =>
  step(context, "resolve default branch", { slug }, async () => {
    const repo = await get(context, `repos/${slug}`);
    return text(repo, "default_branch");
  });

const currentPr = (context: Context, slug: string): Promise<number> =>
  step(context, "resolve current pr", { slug }, async () => {
    const branch = await currentBranch(context);
    const pulls = await listAll(context, `repos/${slug}/pulls?state=open`);
    const matching = pulls.filter((pr) => refOf(pr, "head") === branch);
    const [pr] = matching;
    if (pr === undefined || matching.length > 1) {
      throw new Error(
        `expected one open PR for branch '${branch}', found ${matching.length}; pass its number`,
      );
    }
    return integer(pr, "number");
  });

const labelId = (context: Context, slug: string, name: string) =>
  step(context, "resolve label", { slug, name }, async () => {
    const found = await listAll(context, `repos/${slug}/labels`);
    const label = found.map(toLabel).find((each) => each.name === name);
    if (label === undefined) {
      throw new Error(`label '${name}' does not exist in ${slug}`);
    }
    return label.id;
  });

const readBody = (context: Context, path: string): Promise<string> =>
  step(context, "read body", { path }, () =>
    path === "-" ? context.deps.readStdin() : context.deps.readFile(path),
  );

const option = (values: Values, name: string): string | undefined => {
  const value = values[name];
  if (value !== undefined && typeof value !== "string") {
    throw new Error(`--${name} expects a value`);
  }
  return value;
};

const enabled = (values: Values, name: string): boolean =>
  values[name] === true;

const toOptions = (values: Values): Options => ({
  repo: option(values, "repo"),
  state: option(values, "state"),
  title: option(values, "title"),
  bodyFile: option(values, "body-file"),
  label: option(values, "label"),
  base: option(values, "base"),
  head: option(values, "head"),
  method: option(values, "method"),
  json: enabled(values, "json"),
  verbose: enabled(values, "verbose"),
  help: enabled(values, "help"),
});

const required = (value: string | undefined, name: string): string => {
  if (value === undefined) throw new Error(`--${name} is required`);
  return value;
};

const positional = (input: Input, index: number, name: string): string => {
  const value = input.positionals[index];
  if (value === undefined) throw new Error(`missing <${name}>`);
  return value;
};

const toNumber = (value: string): number => {
  if (!/^\d+$/.test(value)) {
    throw new Error(`expected a PR number, got '${value}'`);
  }
  return Number(value);
};

const prNumber = async (
  context: Context,
  input: Input,
  slug: string,
): Promise<number> => {
  const requested = input.positionals[0];
  if (requested === undefined) return currentPr(context, slug);
  return toNumber(requested);
};

const methodOf = (requested: string | undefined, body: unknown): Method => {
  if (requested === undefined) return body === undefined ? "GET" : "POST";
  const method = requested.toUpperCase();
  if (!isMethod(method)) {
    throw new Error(`supported methods: ${METHODS.join(", ")}`);
  }
  return method;
};

const jsonBody = async (
  context: Context,
  path: string | undefined,
): Promise<unknown> => {
  if (path === undefined) return undefined;
  const raw = await readBody(context, path);
  return parseJson(raw, "JSON body");
};

const runApi = async (context: Context, input: Input): Promise<string> => {
  const endpoint = positional(input, 0, "endpoint");
  const body = await jsonBody(context, input.options.bodyFile);
  const method = methodOf(input.options.method, body);
  const response = await request(context, method, endpoint, body);
  return response === undefined ? "" : JSON.stringify(response, null, 2);
};

const runLabels = async (context: Context, input: Input): Promise<string> => {
  const slug = await repository(context, input.options.repo);
  const labels = await listAll(context, `repos/${slug}/labels`);
  const rows = labels.map(toLabel);
  return render(rows, input.options.json);
};

const runWebhooks = async (context: Context, input: Input): Promise<string> => {
  const slug = await repository(context, input.options.repo);
  const hooks = await listAll(context, `repos/${slug}/hooks`);
  const rows = hooks.map(toWebhook);
  return render(rows, input.options.json);
};

const webhookId = (value: string): number => {
  const id = Number(value);
  if (!/^[1-9]\d*$/.test(value) || !Number.isSafeInteger(id)) {
    throw new Error(`expected a webhook ID, got '${value}'`);
  }
  return id;
};

const runWebhookDelete = async (
  context: Context,
  input: Input,
): Promise<string> => {
  const idValue = positional(input, 0, "id");
  const id = webhookId(idValue);
  const slug = await repository(context, input.options.repo);
  await request(context, "DELETE", `repos/${slug}/hooks/${id}`, undefined);
  return render({ id, repo: slug, state: "deleted" }, input.options.json);
};

const stateQuery = (state: string | undefined): string =>
  state === undefined ? "" : `?state=${encodeURIComponent(state)}`;

const runPrList = async (context: Context, input: Input): Promise<string> => {
  const slug = await repository(context, input.options.repo);
  const query = stateQuery(input.options.state);
  const pulls = await listAll(context, `repos/${slug}/pulls${query}`);
  const rows = pulls.map(toSummary);
  return render(rows, input.options.json);
};

const runPrView = async (context: Context, input: Input): Promise<string> => {
  const slug = await repository(context, input.options.repo);
  const index = await prNumber(context, input, slug);
  const pr = await get(context, `repos/${slug}/pulls/${index}`);
  const summary = toSummary(pr);
  return render({ ...summary, body: text(pr, "body") }, input.options.json);
};

const runPrCreate = async (context: Context, input: Input): Promise<string> => {
  const title = positional(input, 0, "title");
  const bodyFile = required(input.options.bodyFile, "body-file");
  const label = required(input.options.label, "label");
  const slug = await repository(context, input.options.repo);
  const head = input.options.head ?? (await currentBranch(context));
  const base = input.options.base ?? (await defaultBranch(context, slug));
  const payload = {
    title,
    head,
    base,
    body: await readBody(context, bodyFile),
    labels: [await labelId(context, slug, label)],
  };
  const created = await request(
    context,
    "POST",
    `repos/${slug}/pulls`,
    payload,
  );
  const summary = toSummary(created);
  return render(summary, input.options.json);
};

const editPayload = async (
  context: Context,
  options: Options,
): Promise<Record<string, string>> => {
  const { title, bodyFile } = options;
  const body =
    bodyFile === undefined ? undefined : await readBody(context, bodyFile);
  return {
    ...(title === undefined ? {} : { title }),
    ...(body === undefined ? {} : { body }),
  };
};

const updatePr = (
  context: Context,
  endpoint: string,
  payload: Record<string, string>,
): Promise<unknown> =>
  Object.keys(payload).length === 0
    ? get(context, endpoint)
    : request(context, "PATCH", endpoint, payload);

const assignLabel = async (
  context: Context,
  slug: string,
  index: number,
  name: string,
): Promise<string[]> => {
  const id = await labelId(context, slug, name);
  const assigned = await request(
    context,
    "PUT",
    `repos/${slug}/issues/${index}/labels`,
    { labels: [id] },
  );
  return labelNames(assigned);
};

const requireEdit = (options: Options): void => {
  const changes = [options.title, options.bodyFile, options.label];
  if (changes.every((change) => change === undefined)) {
    throw new Error("pass at least one of --title, --body-file or --label");
  }
};

const runPrEdit = async (context: Context, input: Input): Promise<string> => {
  const { options } = input;
  requireEdit(options);
  const slug = await repository(context, options.repo);
  const index = await prNumber(context, input, slug);
  const payload = await editPayload(context, options);
  const updated = await updatePr(
    context,
    `repos/${slug}/pulls/${index}`,
    payload,
  );
  const summary = toSummary(updated);
  if (options.label === undefined) return render(summary, options.json);
  const labels = await assignLabel(context, slug, index, options.label);
  return render({ ...summary, labels }, options.json);
};

const isLatestApproval = (
  review: unknown,
  index: number,
  reviews: unknown[],
): boolean => {
  const user = property(review, "user");
  const login = text(user, "login");
  const later = reviews.slice(index + 1).some((each) => {
    const laterUser = property(each, "user");
    const laterLogin = text(laterUser, "login");
    return laterLogin === login;
  });
  return (
    !later &&
    text(review, "state") === "APPROVED" &&
    boolean(review, "official") &&
    !boolean(review, "dismissed")
  );
};

const reviewedBy = (review: unknown): string => {
  const user = property(review, "user");
  const fullName = text(user, "full_name");
  const name = fullName === "" ? text(user, "login") : fullName;
  return `Reviewed-by: ${name} <${text(user, "email")}>`;
};

const squashMessage = async (
  context: Context,
  slug: string,
  index: number,
  pr: unknown,
): Promise<string> => {
  const reviews = await listAll(
    context,
    `repos/${slug}/pulls/${index}/reviews`,
  );
  const approvers = reviews.filter(isLatestApproval).map(reviewedBy);
  return [`Reviewed-on: ${text(pr, "html_url")}`, ...approvers].join("\n");
};

const runPrMerge = async (context: Context, input: Input): Promise<string> => {
  const slug = await repository(context, input.options.repo);
  const index = await prNumber(context, input, slug);
  const endpoint = `repos/${slug}/pulls/${index}`;
  const pr = await get(context, endpoint);
  const repo = await get(context, `repos/${slug}`);
  const payload = {
    Do: "squash",
    MergeTitleField: `${text(pr, "title")} (#${index})`,
    MergeMessageField: await squashMessage(context, slug, index, pr),
    delete_branch_after_merge: boolean(
      repo,
      "default_delete_branch_after_merge",
    ),
  };
  await request(context, "POST", `${endpoint}/merge`, payload);
  const merged = await get(context, endpoint);
  const summary = toSummary(merged);
  return render(summary, input.options.json);
};

const REPO: Flag = {
  type: "string",
  description: "owner/repo, detected from origin when omitted",
};

const JSON_OUTPUT: Flag = { type: "boolean", description: "output JSON" };

const BODY_FILE: Flag = {
  type: "string",
  description: "markdown file with the PR body, - reads stdin",
};

const COMMON: Record<string, Flag> = {
  verbose: { type: "boolean", description: "log steps to stderr" },
  help: { type: "boolean", description: "show this help" },
};

const COMMANDS: Command[] = [
  {
    name: "api",
    usage: "api <endpoint>",
    positionals: 1,
    flags: {
      method: {
        type: "string",
        description: "GET, POST, PATCH, PUT or DELETE; GET or POST by body",
      },
      "body-file": {
        type: "string",
        description: "JSON request body file, - reads stdin",
      },
    },
    run: runApi,
  },
  {
    name: "labels",
    usage: "labels",
    positionals: 0,
    flags: { repo: REPO, json: JSON_OUTPUT },
    run: runLabels,
  },
  {
    name: "webhooks delete",
    usage: "webhooks delete <id>",
    positionals: 1,
    flags: { repo: REPO, json: JSON_OUTPUT },
    run: runWebhookDelete,
  },
  {
    name: "webhooks",
    usage: "webhooks",
    positionals: 0,
    flags: { repo: REPO, json: JSON_OUTPUT },
    run: runWebhooks,
  },
  {
    name: "pr list",
    usage: "pr list",
    positionals: 0,
    flags: {
      repo: REPO,
      state: { type: "string", description: "open, closed or all" },
      json: JSON_OUTPUT,
    },
    run: runPrList,
  },
  {
    name: "pr view",
    usage: "pr view [number]",
    positionals: 1,
    flags: { repo: REPO, json: JSON_OUTPUT },
    run: runPrView,
  },
  {
    name: "pr create",
    usage: "pr create <title> --body-file <file> --label <label>",
    positionals: 1,
    flags: {
      "body-file": BODY_FILE,
      label: { type: "string", description: "existing label name" },
      repo: REPO,
      base: {
        type: "string",
        description: "target branch, repo default branch when omitted",
      },
      head: {
        type: "string",
        description: "source branch, current branch when omitted",
      },
      json: JSON_OUTPUT,
    },
    run: runPrCreate,
  },
  {
    name: "pr edit",
    usage: "pr edit [number]",
    positionals: 1,
    flags: {
      title: { type: "string", description: "new PR title" },
      "body-file": BODY_FILE,
      label: {
        type: "string",
        description: "existing label name, replaces current labels",
      },
      repo: REPO,
      json: JSON_OUTPUT,
    },
    run: runPrEdit,
  },
  {
    name: "pr merge",
    usage: "pr merge [number]",
    positionals: 1,
    flags: { repo: REPO, json: JSON_OUTPUT },
    run: runPrMerge,
  },
];

const flagsOf = (command: Command): Record<string, Flag> => ({
  ...command.flags,
  ...COMMON,
});

const usage = (): string => {
  const lines = COMMANDS.map((command) => `codeberg ${command.usage}`);
  return [
    ...lines,
    "Use --help on a command for its flags. Authentication: CODEBERG_TOKEN.",
  ].join("\n");
};

const flagLine = ([name, flag]: [string, Flag]): string =>
  `  --${name}${flag.type === "string" ? " <value>" : ""}  ${flag.description}`;

const helpOf = (command: Command): string => {
  const flags = flagsOf(command);
  const lines = Object.entries(flags).map(flagLine);
  return [`codeberg ${command.usage}`, ...lines].join("\n");
};

const wordsOf = (command: Command): string[] => command.name.split(" ");

const matches = (argv: string[], command: Command): boolean =>
  wordsOf(command).every((word, index) => argv[index] === word);

const findCommand = (argv: string[]): Command => {
  const command = COMMANDS.find((candidate) => matches(argv, candidate));
  if (command === undefined) {
    throw new Error(`unknown command '${argv.join(" ")}'\n${usage()}`);
  }
  return command;
};

const optionsConfig = (
  command: Command,
): Record<string, { type: Flag["type"] }> => {
  const flags = flagsOf(command);
  const entries = Object.entries(flags).map(
    ([name, flag]): [string, { type: Flag["type"] }] => [
      name,
      { type: flag.type },
    ],
  );
  return Object.fromEntries(entries);
};

const parseInput = (command: Command, argv: string[]): Input => {
  const args = argv.slice(wordsOf(command).length);
  const options = optionsConfig(command);
  const { values, positionals } = parseArgs({
    args,
    options,
    strict: true,
    allowPositionals: true,
  });
  if (positionals.length > command.positionals) {
    throw new Error(`unexpected argument '${positionals.join(" ")}'`);
  }
  return { positionals, options: toOptions(values) };
};

const isHelp = (argv: string[]): boolean =>
  argv.length === 0 || argv[0] === "--help" || argv[0] === "-h";

export const run = async (argv: string[], deps: Deps): Promise<string> => {
  if (isHelp(argv)) return usage();
  const command = findCommand(argv);
  const input = parseInput(command, argv);
  if (input.options.help) return helpOf(command);
  const context = { deps, verbose: input.options.verbose };
  return command.run(context, input);
};

const git = async (args: string[]): Promise<string> => {
  const child = Bun.spawn(["git", ...args], { stdout: "pipe", stderr: "pipe" });
  const [stdout, stderr, code] = await Promise.all([
    new Response(child.stdout).text(),
    new Response(child.stderr).text(),
    child.exited,
  ]);
  if (code !== 0) throw new Error(`git ${args.join(" ")}: ${stderr.trim()}`);
  return stdout.trim();
};

const main = async (): Promise<void> => {
  const deps: Deps = {
    fetch: (url, init) => fetch(url, init),
    git,
    token: Bun.env["CODEBERG_TOKEN"],
    readFile: (path) => Bun.file(path).text(),
    readStdin: () => Bun.stdin.text(),
    log: log.info,
  };
  const argv = Bun.argv.slice(2);
  try {
    const result = await run(argv, deps);
    if (result !== "") output.text(result);
  } catch (error: unknown) {
    const message = messageOf(error);
    log.error(message);
    process.exit(1);
  }
};

if (import.meta.main) await main();
