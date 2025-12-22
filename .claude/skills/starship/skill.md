---
name: starship
description: Use when editing ANY starship configuration. Ensures special characters and nerd font icons are preserved using placeholders and converter script. Provides VHS testing workflow.
---

# Starship Skill

## Configuration Location

- Config file: `home/.config/starship.toml`
- Always edit files in the dotfiles repo, not symlinked files in `~/.config/`

## Special Characters and Icons

Claude Code strips unicode characters and nerd font icons. Use placeholders in the config template (`starship.toml` in this skill folder).

### Available Placeholders

#### Arrows
- `{{ARROW_UP}}` - up arrow (⇡)
- `{{ARROW_DOWN}}` - down arrow (⇣)
- `{{ARROW_UPDOWN}}` - up/down arrow (⇕)

#### Version Control
- `{{ICON_GIT_BRANCH}}` - git branch
- `{{ICON_TAG}}` - tag
- `{{ICON_FOSSIL}}` - fossil
- `{{ICON_HG}}` - mercurial
- `{{ICON_PIJUL}}` - pijul

#### Languages
- `{{ICON_BUN}}` - bun (U+E76F)
- `{{ICON_C}}` - C
- `{{ICON_CPP}}` - C++
- `{{ICON_CRYSTAL}}` - crystal
- `{{ICON_DART}}` - dart
- `{{ICON_DENO}}` - deno
- `{{ICON_ELIXIR}}` - elixir
- `{{ICON_ELM}}` - elm
- `{{ICON_GOLANG}}` - go
- `{{ICON_HASKELL}}` - haskell
- `{{ICON_HAXE}}` - haxe
- `{{ICON_JAVA}}` - java
- `{{ICON_JULIA}}` - julia
- `{{ICON_KOTLIN}}` - kotlin
- `{{ICON_LUA}}` - lua
- `{{ICON_NIM}}` - nim
- `{{ICON_NODEJS}}` - nodejs
- `{{ICON_OCAML}}` - ocaml
- `{{ICON_PERL}}` - perl
- `{{ICON_PHP}}` - php
- `{{ICON_PYTHON}}` - python
- `{{ICON_RLANG}}` - R
- `{{ICON_RUBY}}` - ruby
- `{{ICON_RUST}}` - rust
- `{{ICON_SCALA}}` - scala
- `{{ICON_SWIFT}}` - swift
- `{{ICON_ZIG}}` - zig

#### Tools & Cloud
- `{{ICON_AWS}}` - AWS
- `{{ICON_DOCKER}}` - docker
- `{{ICON_GCLOUD}}` - Google Cloud
- `{{ICON_NIX}}` - nix
- `{{ICON_CMAKE}}` - cmake
- `{{ICON_CONDA}}` - conda
- `{{ICON_GRADLE}}` - gradle
- `{{ICON_GUIX}}` - guix
- `{{ICON_MESON}}` - meson
- `{{ICON_PACKAGE}}` - package
- `{{ICON_PIXI}}` - pixi

#### Shells
- `{{ICON_BASH}}` - bash
- `{{ICON_ZSH}}` - zsh
- `{{ICON_FISH}}` - fish
- `{{ICON_POWERSHELL}}` - powershell

#### Other
- `{{ICON_READONLY}}` - read-only directory
- `{{ICON_SSH}}` - SSH
- `{{ICON_MEMORY}}` - memory usage
- `{{ICON_BUF}}` - buf

#### OS Symbols
- `{{ICON_OS_ALPAQUITA}}` - Alpaquita
- `{{ICON_OS_ALPINE}}` - Alpine
- `{{ICON_OS_ALMALINUX}}` - AlmaLinux
- `{{ICON_OS_AMAZON}}` - Amazon
- `{{ICON_OS_ANDROID}}` - Android
- `{{ICON_OS_ARCH}}` - Arch
- `{{ICON_OS_ARTIX}}` - Artix
- `{{ICON_OS_CACHYOS}}` - CachyOS
- `{{ICON_OS_CENTOS}}` - CentOS
- `{{ICON_OS_DEBIAN}}` - Debian
- `{{ICON_OS_DRAGONFLY}}` - DragonFly
- `{{ICON_OS_EMSCRIPTEN}}` - Emscripten
- `{{ICON_OS_ENDEAVOUROS}}` - EndeavourOS
- `{{ICON_OS_FEDORA}}` - Fedora
- `{{ICON_OS_FREEBSD}}` - FreeBSD
- `{{ICON_OS_GARUDA}}` - Garuda
- `{{ICON_OS_GENTOO}}` - Gentoo
- `{{ICON_OS_HARDENEDBSD}}` - HardenedBSD
- `{{ICON_OS_ILLUMOS}}` - Illumos
- `{{ICON_OS_KALI}}` - Kali
- `{{ICON_OS_LINUX}}` - Linux
- `{{ICON_OS_MABOX}}` - Mabox
- `{{ICON_OS_MACOS}}` - macOS
- `{{ICON_OS_MANJARO}}` - Manjaro
- `{{ICON_OS_MARINER}}` - Mariner
- `{{ICON_OS_MIDNIGHTBSD}}` - MidnightBSD
- `{{ICON_OS_MINT}}` - Mint
- `{{ICON_OS_NETBSD}}` - NetBSD
- `{{ICON_OS_NIXOS}}` - NixOS
- `{{ICON_OS_NOBARA}}` - Nobara
- `{{ICON_OS_OPENBSD}}` - OpenBSD
- `{{ICON_OS_OPENSUSE}}` - openSUSE
- `{{ICON_OS_ORACLELINUX}}` - OracleLinux
- `{{ICON_OS_POP}}` - Pop
- `{{ICON_OS_RASPBIAN}}` - Raspbian
- `{{ICON_OS_REDHAT}}` - Redhat
- `{{ICON_OS_REDHATENTERPRISE}}` - RedHatEnterprise
- `{{ICON_OS_ROCKYLINUX}}` - RockyLinux
- `{{ICON_OS_REDOX}}` - Redox
- `{{ICON_OS_SOLUS}}` - Solus
- `{{ICON_OS_SUSE}}` - SUSE
- `{{ICON_OS_UBUNTU}}` - Ubuntu
- `{{ICON_OS_UNKNOWN}}` - Unknown
- `{{ICON_OS_VOID}}` - Void
- `{{ICON_OS_WINDOWS}}` - Windows

### How The Converter Works

**CRITICAL**: The converter uses **unicode code points** via Nushell's `char -i` command, NOT literal unicode characters. This prevents Claude Code from stripping icons when reading/writing the converter script.

**Why This Works**:
- Template: `symbol = "{{ICON_PYTHON}} "` (placeholder + space)
- Converter: `["{{ICON_PYTHON}}" (make_icon 0xE235)]` (code point expression)
- Output: `symbol = " "` (actual icon + space)

The converter file stays safe because it uses expressions like `(make_icon 0xED0D)` instead of literal unicode characters that Claude Code would strip.

### Finding and Changing Icons

**To find icon codes:**

```bash
# Generate HTML for browser viewing (easiest)
show-nerd-icons --html
open tmp/nerd_icons.html
```

Search for your desired icon (e.g., "node", "python"), and note the unicode code point (e.g., U+ED0D).

**To change an icon:**

1. Find the icon code point (e.g., U+ED0D for Node.js)
2. Edit `convert-config` and update the code point:
   ```nushell
   ["{{ICON_NODEJS}}" (make_icon 0xED0D)]
   ```
3. Run the converter:
   ```bash
   .claude/skills/starship/convert-config
   ```

**Example - Fixing Node.js icon:**
```nushell
# Before (wrong icon):
["{{ICON_NODEJS}}" (make_icon 0xE718)]

# After (correct icon):
["{{ICON_NODEJS}}" (make_icon 0xED0D)]
```

### Identifying Wrong Icons

If you don't know which icon is wrong, temporarily show version numbers:

1. Edit template to show versions:
   ```toml
   # Change from:
   format = "[$symbol]($style)"

   # To:
   format = "[$symbol($version )]($style)"
   ```

2. Regenerate and check your prompt - you'll see "icon version" for each language

3. Identify the wrong icon by its position/version

4. Revert the format change after identifying the issue

### Debugging Icons

Check if icons have actual values (not empty strings):

```bash
nu -c 'source .claude/skills/starship/convert-config; debug_icons' | head -50
```

Each icon should show:
- Value: the actual icon character (may display as glyph)
- Length: 1-4 chars (depending on unicode plane)
- Bytes: 3-4 bytes for most nerd font icons

Empty icons (0 bytes, 0 chars) mean the code point is wrong or missing.

## VHS Testing

**CRITICAL: ALWAYS use the tape in this skill folder. NEVER create ad-hoc tape files with different output names.**

Use VHS to verify visual changes:

1. Run the tape from `.claude/skills/starship/`:
   - `starship.tape` - Tests prompt appearance with git status and language icons
2. Output screenshot ALWAYS goes to `tmp/starship.png` (same name, no versioning)
3. Read the screenshot to verify before telling user the fix is complete

## Workflow

### Safe Editing Process

**NEVER edit `home/.config/starship.toml` directly - icons will be stripped!**

Always use this workflow:

1. **Edit the template**: `.claude/skills/starship/starship.toml` using placeholders
   - Example: `symbol = "{{ICON_PYTHON}} "`
   - Template controls spacing (add space after placeholder if needed)

2. **Run the converter**:
   ```bash
   .claude/skills/starship/convert-config
   ```
   - Reads template, replaces placeholders with actual icons
   - Writes to `home/.config/starship.toml`
   - Your prompt updates immediately

3. **Test visually** (optional):
   ```bash
   vhs .claude/skills/starship/starship.tape
   ```
   - Read `tmp/starship.png` to verify

### Important Notes

**Spacing**: The template controls all spacing. The converter only replaces placeholders with icons.
- Good: `symbol = "{{ICON_PYTHON}} "` → icon gets space from template
- Bad: Don't add spaces in converter, template already has them

**Code Points**: All icon mappings are in `convert-config` using hex code points:
```nushell
["{{ICON_PYTHON}}" (make_icon 0xE235)]
["{{ICON_NODEJS}}" (make_icon 0xED0D)]
["{{ICON_RUST}}" (make_icon 0xF1617)]
```

**High Code Points**: Supports extended unicode (> 0xFFFF) for all nerd font variants

## Verification Checklist

Before declaring complete, verify:
- All icons render correctly in the prompt
- Git branch icon appears in git repos
- Git status shows correct arrows and counts
- Language icons appear when in appropriate project directories
- Colors are applied correctly
- No placeholder text like `{{ICON_*}}` appears in the actual prompt

## Common Issues & Solutions

### Issue: Icons appear as empty/blank spaces

**Cause**: Wrong unicode code point in converter

**Solution**:
1. Use `show-nerd-icons --html` to find correct code
2. Update converter: `["{{ICON_NAME}}" (make_icon 0xCODE)]`
3. Regenerate: `.claude/skills/starship/convert-config`

### Issue: Double spacing between icons

**Cause**: Both template AND converter adding spaces

**Solution**: Remove spaces from converter, keep only in template
- Template: `symbol = "{{ICON_PYTHON}} "` ✓
- Converter: `(make_icon 0xE235)` ✓ (no space)

### Issue: Can't identify which icon is wrong

**Solution**: Temporarily show version numbers in prompt
1. Edit all language formats in template: `format = "[$symbol($version )]($style)"`
2. Regenerate and check prompt
3. Identify wrong icon by its position
4. Revert format changes

### Issue: Converter fails with "can't convert int to string"

**Cause**: Wrong Nushell syntax for `char` command

**Solution**: Use `char -i` (integer flag) not `char -u`:
```nushell
# Correct:
def make_icon [code: int] { char -i $code }

# Wrong:
def make_icon [code: int] { char -u $code }
```

## Key Learnings

1. **Never edit the final config** (`home/.config/starship.toml`) - always edit the template
2. **Template controls spacing** - converter only replaces placeholders
3. **Use code points** - `(make_icon 0xED0D)` not literal characters
4. **All icons extracted** from user's original config - preserves user's icon choices
5. **Supports high code points** - works with extended nerd font ranges (> 0xFFFF)
