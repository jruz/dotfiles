---
name: zellij-layout
description: Use when editing zellij layout or zjstatus plugin configuration. Provides rules for powerline characters, VHS testing, and verification.
---

# Zellij Layout Skill

## Configuration Locations

- Layout files: `home/.config/zellij/layouts/`
- Plugin file: `home/.config/zellij/plugins/zjstatus.wasm`
- Always edit files in the dotfiles repo, not symlinked files in `~/.config/`

## Powerline Characters

Claude Code strips unicode characters. Use placeholders in the layout file (`layout.kdl` in this skill folder):

- `{{PL_RIGHT}}` - right-pointing arrow (U+E0B0)
- `{{PL_LEFT}}` - left-pointing arrow (U+E0B2)

After editing the layout, run the converter:

```bash
~/.claude/skills/zellij-layout/convert-layout
```

This reads `layout.kdl` from the skill folder, replaces placeholders with actual powerline chars, and writes to `~/.config/zellij/layouts/layout.kdl`.

## VHS Testing

**CRITICAL: NEVER run zellij commands in the user's active session. VHS creates its own isolated terminal.**

Use VHS to verify visual changes:

1. Delete any existing test session: `zellij delete-session zellij-test`
2. Run the tape at `~/.claude/skills/zellij-layout/layout.tape`
3. Output screenshot goes to `tmp/zellij-layout.png` (always same name, no versioning)
4. Read the screenshot to verify before telling user the fix is complete
5. Clean up the test session: `zellij delete-session zellij-test`

The tape creates a dedicated `zellij-test` session. Never use `zellij action` commands directly - they affect the user's current session.

## Color Scheme

Use Catppuccin Mocha colors. Reference by name in requirements:
- base, surface1, lavender, text (not hex codes)

## Top Bar Layout

- Session name, tabs with powerline arrows, hostname/username
- Arrows between tabs use base color as foreground
- Active tab: accent background, base text color
- Inactive tabs: surface background, text color

## Bottom Bar Layout

- Mode indicator, active tab name only, datetime
- Show only active tab name (no inactive tabs)

## Verification Checklist

Before declaring complete, verify:
- Top bar arrows use dark/base color between all tabs
- No accent color triangles between inactive tabs
- Bottom bar shows only active tab name
- Bottom bar has no powerline triangles
- Session name arrow transitions correctly to first tab
