# Zellij Templates

## Overview

This specification defines how to work with zellij layout templates and zjstatus plugin configuration in the dotfiles repository.

## Related Specifications

- [CLAUDE.md](../../CLAUDE.md) - Repository overview and development workflow

## Configuration Location

THE zellij layout files SHALL be located in `home/.config/zellij/layouts/`.

THE zjstatus plugin file SHALL be located at `home/.config/zellij/plugins/zjstatus.wasm`.

WHERE layout changes are made THE developer SHALL edit files in the dotfiles repository, not the symlinked files in `~/.config/`.

## VHS Testing

THE developer SHALL use VHS to verify visual changes to zellij templates.

THE VHS tape template SHALL be located at `specs/zellij/templates.tape`.

THE VHS output screenshot SHALL always be named `tmp/zellij-template.png`, replacing any existing file.

THE developer SHALL NOT create multiple versioned screenshots (e.g., `preview-1.png`, `preview-final.png`).

WHEN verifying changes THE developer SHALL read the screenshot and confirm correctness before telling the user the fix is complete.

## Session Cleanup

BEFORE running VHS THE developer SHALL delete any existing test session using the session name from the tape file.

AFTER verifying the screenshot THE developer SHALL clean up the test session.

## Powerline Characters

WHERE powerline characters are needed THE developer SHALL use Python to write the config file.

THE Edit tool strips unicode characters, so direct editing SHALL NOT be used for powerline symbols.

## Color Scheme

THE zellij templates SHALL use Catppuccin Mocha colors.

THE color variable names (base, surface1, lavender, text) SHALL be used in requirements instead of hex codes.

## Top Bar Layout

THE top bar SHALL display: session name, tabs with powerline arrows, and mode indicator.

THE arrows between tabs SHALL use base color as foreground, not accent color.

THE active tab SHALL have accent background with base text color.

THE inactive tabs SHALL have surface background with text color.

## Bottom Bar Layout

THE bottom bar SHALL display: hostname, username, active tab name only, and datetime.

THE bottom bar tabs section SHALL show only the active tab name.

THE bottom bar tabs section SHALL NOT display inactive tabs.

THE bottom bar tabs section SHALL NOT use powerline arrows.

## Verification Checklist

BEFORE declaring a fix complete THE developer SHALL verify:

- Top bar arrows use dark/base color between all tabs
- No accent color triangles appear between inactive tabs
- Bottom bar shows only the active tab name
- Bottom bar has no powerline triangles
- Session name arrow transitions correctly to first tab
