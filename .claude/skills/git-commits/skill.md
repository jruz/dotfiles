---
name: git-commits
description: Structure commits for reviewable PRs. Use when committing code or organizing work into commits.
---

# Git Commits (Dotfiles)

Conventions for commits in the dotfiles repository.

## Commit Message Format

THE commit message SHALL follow the format: `Tool: Description`

**Examples:**
```
Neovim: Add completion plugin
Zsh: Update PATH configuration
Starship: Fix prompt icon rendering
```

THE Tool SHALL be the primary configuration area being changed.

THE Description SHALL be a brief imperative action.

THE commit message SHALL NOT end with a period.

## Atomic Commits

THE commit SHALL represent a single logical change.

THE commit SHALL address one concern or configuration change.

THE commit SHALL NOT mix unrelated changes.

## Workflow

### Principles

- **Atomic** - One logical change per commit
- **Testable** - Configuration loads without errors
- **Sequential** - Tell a story, building on previous commits
- **Separated** - Refactoring separate from new features

### Best Practices

1. Refactor existing configs first (separate commit)
2. Add new configuration (separate commit)
3. Test that configs load properly

## Cleanup Before PR

THE developer SHALL use `git rebase -i` to organize commits into a logical story.

Common rebase actions: `pick`, `reword`, `squash`, `fixup`, `drop`
