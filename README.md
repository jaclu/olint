# Olint

Olint is a standalone linting tool designed to operate independently of Git.
It detects available linters and scans the file tree starting from the current
working directory, prioritizing recently changed files.

It is ideal for examining already checked-out projects or local code not in a repository.

Successfully linted files are recorded in a cache with their last modification time.
On subsequent runs, unchanged files are skipped.

## Installation

1. Download the latest release or clone the repository.
2. Run:

```sh
./deploy
```

to install or update Olint.

1. List available linters:

```sh
olint -c
```

Install any missing linters you plan to use.

## Usage

Run Olint:

```sh
olint [options]
```

Example:

```sh
olint -s
```

This lists all detected linters (excluding those in `.olint.conf`) and the file types they process.

## Supported Linters

- **Ansible:** `ansible-lint`
- **Python:** `bandit`, `black`, `flake8`, `isort`, `mypy`, `pycodestyle`, `pyflakes`,
  `pylint`, `pyright`, `ruff`
- **Bash/Posix:** `bashate`, `checkbashisms`, `shellcheck`
- **C/C++:** `cppcheck`
- **JavaScript/TypeScript:** `rslint`
- **Markdown:** `markdownlint`, `markdownlint-cli2`, `pymarkdown`
- **JSON:** `jsonlint`
- **TOML:** `taplo`
- **YAML:** `yamllint`
- **Spelling checks:** `codespell` (checks comments for typos)

Additional linters can be added via plugins in the `plugins` folder.
Linters not installed are skipped automatically.

## Configuration

Olint reads configuration in this order:

1. Global: `$XDG_CONFIG_HOME/olint/olint.conf` or `~/.config/olint/olint.conf`
2. Project: `.olint.conf` in the project root (overrides global settings)

A project must have an `.olint.conf` (can be empty) to define its root.
This prevents accidental linting of the entire filesystem.

### Example `.olint.conf`

```bash
#!/usr/bin/env bash
# This is sourced. Fake bang-path to help editors and linters

# Skip specific installed linters
skip_linters+=(
    markdownlint
)

# Exclude paths by prefix
excluded_prefixes+=(
    test/
    .venv/
)

# Exclude paths by suffix
excluded_suffixes+=(
    .sqlite
)

# Explicitly exclude files
excludes+=(
    data/dead_code.py
)

# Exclude by basename prefix
excluded_basename_prefixes+=(
    \#
)
```

### Custom Linter Commands

Can be added to `.olint.conf` to give project specific command-line options

```bash
override_linter_cmd["codespell"]="codespell -L THIS"
override_linter_cmd["flake8"]="flake8 --color=always --exclude './.venv,./test'"
```

### Project-wide Linters

```bash
project_linters+=(
    bandit
    black
    flake8
    isort
    markdownlint
    mypy
    pycodestyle
    pyright
    ruff
)
```

## Cache

Olint stores a cache in `.cache.olint` with each file's modification time and relative path.
On subsequent runs, unchanged files are skipped.

## Plugins

Plugins define linter behavior via Bash variables in the `plugins` folder.

Optional plugin settings:

- **`plugin_priority`**: Determines which linter runs first if multiple match a file
  (default: 50, higher are executed first)
- **`proj_plugin_cmd`**: Command used when the linter runs as a project-wide tool
- **`plugin_extensions`**: List of handled file extensions
- **`plugin_file_types`**: File types (from `file -b`) that the plugin handles;
  case-insensitive, supports wildcards

## olint venv

if there is a venv present in in `~/.config/olint/.venv` this venv will be activated
and used during the run of `olint`. Ideal place to store python linters, in order to not
have to add them on a project bases.

## Limited systems

Examples how to use this on more limited systems

### iSH Recommendations

Ansible 32-bit does not support `shellcheck`.

In recent versions many linters can be installed via apk

```sh
sudo apk add black checkbashisms cppcheck py3-codespell py3-flake8 py3-isort py3-mypy \
    py3-pycodestyle py3-pyflakes py3-pylint yamllint
```

Some of those missing can be installed via pip (create a virtual environment in
`~/.config/olint/.venv`)

```sh
pip install black codespell flake8 isort mypy pycodestyle pyflakes pylint \
     yamllint
```

Some linters are only available via pip

```sh
pip install bashate bandit pymarkdown
```

Example `~/.config/olint/olint.conf` snippet for iSH:

```bash
skip_linters+=(
    # skipping several tools that are not usable on iSH

    # crashes on iSH
    ansible-lint
    pyright
    ruff
)
```

### Termux Recommendations

Termux supports global pip installs, no virtual environment required. Example setup:

```sh
apt install ruff cppcheck shellcheck nodejs npm
npm install -g jsonlint

pip install bandit bashate codespell pymarkdown mypy pycodestyle pyflakes pylint yamllint
```

## Contributing

Contributions are welcome. Report issues or submit pull requests.

## License

Olint is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
