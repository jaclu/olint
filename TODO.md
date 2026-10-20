# ToDo

## plugin cmd check and usage

plugin_cmd - check this if available
plugin_cmd_actual - if defined also check this, and use as plugin commandproj_plugin_cmd

investigate in oxlint as oxlint as a much faster alternative than rslint

## filetypes only handled by proj linters

Are mistakenly listed as --no-linter - should not be

## dependencies

List of plugins disabled under plugins making them redundant

black
ruff-format

mypy
pyright

ruff
flake8
isort
pylint

flake8 | ruff
pycodestyle
pyflakes

shellcheck
bash-n

## ruff is not always run as proj linter

if the other ruff is named ruff-format only that is run as proj linter
ruff gets ignored, temp fix ruff-format -> ruff_format - investigate reason

## pyflakes

supposedly redundant if flake8 is found, however flake8 seems unable
to find `#hepp` without complaining about missing space

## outside of project

use other_files or similar in .olint.conf to list files outside the project
that should be linted, such as ~/.config/common_pull_config

## Seems to ignore CtrlC

- jsonlint
- rslint

## plugin order

> 200 - executable/syntax validation
> 199-100 - source-modifying handlers
> <100 - analysis handlers, all seeing the same final source

### Python

210 py-compile

120 ruff-check ruff check [--fix if ruff_change_code=1]

115 isort
110 ruff-format - ruff format
108 black [if no ruff-format]

90 ruff-check [use_isort_style_import_ordering=1 disables some versions]

85 flake8 [if no ruff]
75 pycodestyle [if neither ruff/flake8]
70 pyflakes [if neither ruff/flake8]
50 mypy
35 pyright [if no mypy]
25 bandit
20 vulture
10 pylint [skipped if ruff and pyright installed]

### shell script

220 bash-n # Extremely basic check, should only be enabled if shellcheck is unavailable

150 shfmt - used if shfmt_change_code=1 - rewrites code
... Autoformat shell script source code, when using -w rewrites code

85 shfmt - used if shfmt_change_code != 1
50 shellcheck # Linter for shell scripts
40 bashate # Code style enforcement for bash programs
30 checkbashisms # Checks for portability issues in shell scripts

### markdown

70 markdownlint-cli2 # inter for Markdown files
69 markdownlint # Linter for Markdown files
68 pymarkdownlint # Linter for Markdown files

### yaml/ansible

70 yamllint # Linter for YAML files
15 ansible-lint # Checks ansible playbooks for practices and behaviour

### unsorted

98 codespell # Fix common misspellings in source code and text files
70 jsonlint # JSON file linter
70 taplo # TOML toolkit written in Rust
50 cppcheck # Linter for C & C++
50 rslint # Linter for Rust code
