---
name: zellij
description: Use when editing ANY zellij configuration including layouts, swap layouts, keybindings, or zjstatus plugin. Provides rules for powerline characters, VHS testing, and verification.
---

# Zellij Skill

## Configuration Locations

- Layout files: `home/.config/zellij/layouts/`
- Plugin file: `home/.config/zellij/plugins/zjstatus.wasm`
- Always edit files in the dotfiles repo, not symlinked files in `~/.config/`

## Powerline Characters

Claude Code strips unicode characters. Use placeholders when editing:

- `{{PL_RIGHT}}` - right-pointing arrow (U+E0B0) - used for left-to-right transitions
- `{{PL_LEFT}}` - left-pointing arrow (U+E0B2) - used for right-to-left transitions

After editing any layout file, convert placeholders to actual unicode:

```bash
.claude/skills/zellij/convert-layout home/.config/zellij/layouts/layout.kdl
```

### Powerline Pattern Reference

**Session name** (left side, transitions right into tabs):
```
"#[bg=accent,fg=base,bold] {session} #[bg=base,fg=accent]{{PL_RIGHT}}{tabs}"
```

**Tab formats** (arrow in, content, arrow out):
```
tab_normal  "#[bg=surface,fg=base]{{PL_RIGHT}}#[bg=surface,fg=text] {index} {name} #[bg=base,fg=surface]{{PL_RIGHT}}"
tab_active  "#[bg=accent,fg=base]{{PL_RIGHT}}#[bg=accent,fg=base,bold] {index} {name} #[bg=base,fg=accent]{{PL_RIGHT}}"
```

**Right-side elements** (user/host - arrows point left):
```
command_user_format  "#[fg=surface]{{PL_LEFT}}#[bg=surface,fg=text] {stdout} #[fg=accent,bg=surface]{{PL_LEFT}}"
command_host_format  "#[bg=accent,fg=base,bold] {stdout} "
```

**Mode indicators** (bottom bar left side):
```
mode_normal  "#[bg=accent,fg=base,bold] NORMAL #[bg=base,fg=accent]{{PL_RIGHT}}"
mode_tmux    "#[bg=peach,fg=base,bold] TMUX #[bg=base,fg=peach]{{PL_RIGHT}}"
```

**Datetime** (bottom bar right side - arrows point left):
```
datetime  "#[fg=surface]{{PL_LEFT}}#[bg=surface,fg=text] Label #[fg=accent,bg=surface]{{PL_LEFT}}#[bg=accent,fg=base,bold] {format} "
```

## VHS Testing

**CRITICAL: NEVER run zellij commands in the user's active session. VHS creates its own isolated terminal.**

**CRITICAL: ALWAYS use the tapes in this skill folder. NEVER create ad-hoc tape files with different output names.**

Use VHS to verify visual changes:

1. Delete any existing test session: `zellij delete-session zellij-test`
2. Run the appropriate tape from `.claude/skills/zellij/`:
   - `layout.tape` - Tests tabs and zjstatus bar appearance
   - `swap-layout.tape` - Tests swap layouts with multiple panes
3. Output screenshot ALWAYS goes to `tmp/zellij.png` (same name, no versioning)
4. Read the screenshot to verify before telling user the fix is complete
5. Clean up the test session: `zellij delete-session zellij-test`

## Color Scheme

Use Catppuccin Mocha colors:
- base: #1e1e2e
- surface (surface1): #45475a
- text: #cdd6f4
- lavender (accent): #b4befe
- peach: #fab387
- red: #f38ba8
- sky: #89dceb

## Verification Checklist

Before declaring complete, verify:
- Top bar arrows use dark/base color between all tabs
- No accent color triangles between inactive tabs
- Bottom bar shows only active tab name
- Session name arrow transitions correctly to first tab
