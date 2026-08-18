# ToDo

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

## order for shell check

Shoulddn't bashate go before shellcheck?

## pyflakes

supposedly redundant if flake8 is found, however flake8 seems unable
to find `#hepp` without complaining about missing space

## Dont list files covered by project linters as `No linter`

## order project linter by prio

initially just use the existing prio variable

dummy change

## outside of project

use other_files or similar in .olint.conf to list files outside the project
that should be linted, such as ~/.config/common_pull_config

## CtrlC

- jsonlint ignores ctrl c
- rslint ignores ctrl c

> 200 - executable/syntax validation
> 199-100 - source-modifying handlers
> <100 - analysis handlers, all seeing the same final source

### Python

210 py-compile

120 ruff-check --fix [if $ruff_change_code is 1 and not (
isort_allow_usage=1 and isort found and I001 used)]

115 isort [isort_allow_usage=1]
110 ruff-format [if not black_allow_usage=1 and black found]
108 black [black_allow_usage=1]

90 ruff-check [ruff_change_code=0 and not (
isort_allow_usage=1 and isort found and I001 used)]

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
50 openrc # Limied OpenRC service script linting via shellcheck
50 rslint # Linter for Rust code
