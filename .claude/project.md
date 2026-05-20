# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Olint is a Git-independent multi-linter orchestrator written in Bash. It recursively
scans the current directory, detects which linters are installed, and runs them against
matching files — prioritizing recently modified files. It caches results (`.cache.olint`)
to skip unchanged files on subsequent runs.

## Key Commands

```bash
./deploy                  # Install olint + plugins to ~/.local/bin + config to ~/.config/olint/
./deploy force            # Force reinstall
./deploy uninstall        # Remove everything

olint                     # Lint files in current directory (respects cache)
olint -c                  # Show configuration + available/unavailable linters
olint -Z                  # Clear cache and run (relint everything)
olint -N -C               # No cache, continue after linting errors
olint 24                  # Only lint files changed in last 24 hours
```

There are no automated tests — olint validates itself by self-linting its own source files.

## Architecture

**Single main script:** `olint` (~2,300 lines of Bash) contains all orchestration logic.
There is no build step; the script runs directly.

**Deployment:** `deploy` copies `olint` and all `plugins/` files to `~/.local/bin` and
`~/.config/olint/plugins/`. Changes to source files require re-running `./deploy` to
take effect.

**Plugin system:** Each file in `plugins/` is a Bash snippet sourced at startup. Plugins define:

- `plugin_cmd` — command for individual-file linting
- `proj_plugin_cmd` — command for whole-project linting
- `plugin_priority` — execution order (higher runs first; see tier table below)
- `plugin_extensions` — file extensions handled (e.g., `.sh .bash`)
- `plugin_file_types` — MIME type patterns from `file -b` output

**Project root discovery:** Olint searches upward from the current directory until it finds
`.olint.conf`, then lints from that directory. Running olint from anywhere in the project
tree always covers the full project. The cache (`.cache.olint`) is stored alongside
`.olint.conf` at the root, so cache state is consistent regardless of invocation depth.

**Configuration hierarchy** (later overrides earlier):

1. Global: `~/.config/olint/olint.conf`
2. Project: `.olint.conf` at the discovered project root (required; can be empty)

**Main execution flow:**

```text
initialize_env → get_config → parse_cmd_line → check_linter_plugins
→ cache_read → process_file_tree (files sorted newest-first by mtime)
  → for each file: exclusion check → cache check → lint_by_ext / lint_by_file_type
  → for each project linter: lint_proj
→ env_cleanup (save cache, print stats)
```

**Platform handling:** The script detects iSH (iPad/Alpine 32-bit) and Termux (Android)
and adjusts behavior — skipping linters that crash on those platforms, using simpler
`find` commands, and adding load monitoring.

**Caching:** `.cache.olint` maps filenames to mtimes. Files whose mtime hasn't changed
since the last successful lint are skipped. Ctrl-C saves the cache before exiting.

## Adding a New Linter Plugin

Create a file in `plugins/<lintername>` following the pattern of existing plugins, then
re-run `./deploy` to install it. The plugin must set `plugin_cmd` (and optionally
`proj_plugin_cmd`, `plugin_priority`, `plugin_extensions`, `plugin_file_types`).

Assign `plugin_priority` based on the linter's speed and depth. The goal is fail-fast:
cheap checks catch trivial issues before slow linters waste a full pass.

| Tier | Range | Characteristic | Examples |
| ---- | ----- | -------------- | -------- |
| Auto-fix formatters | 80–95 | Modify the file in place | shfmt (85), black (80), ruff (90) |
| Fast style/syntax | 60–79 | Fast, catch trivial issues | flake8 (70), yamllint (70), markdownlint (70) |
| Static analysis | 40–59 | Correct but slower | shellcheck (50), cppcheck (50) |
| Type checkers | 20–39 | Slow, need clean code first | mypy (30), pyright (35) |
| Deep/comprehensive | 1–19 | Slowest, most thorough | pylint (20), bandit (10), ansible-lint (15) |

Formatters that modify files (shfmt `-w`, black, isort) always go 80+ so subsequent
linters see the already-formatted file. `bashate` is intentionally kept at 30 — it runs
as a residual policy check after shfmt (85) and shellcheck (50) have already handled
formatting and deeper analysis. `bash-n` is iSH-only; it self-disables when shellcheck
is present and is also disabled in the global config on normal machines.

## Configuration Keys

| Key | Purpose |
| --- | ------- |
| `skip_linters` | Disable specific linters by name |
| `excluded_prefixes` | Skip directory/file path prefixes (e.g., `.git/`) |
| `excluded_suffixes` | Skip files by suffix (e.g., `.pyc`) |
| `project_linters` | Linters that run on the entire project (e.g., `mypy codespell`) |
| `override_linter_cmd[name]` | Override the command for a specific linter |
| `use_cache` | Enable/disable caching (default: `true`) |
