# ToDo

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

## Linter pips

bandit
flake8
jsonlint
pycodestyle
pylint
yamllint

90 - ruff

40 - pyright
30 - mypy
20 - pylint
10 - bandit

## no ruff

90 - isort
80 - black
70 - flake8

40 - pyright
30 - mypy
20 - pylint
10 - bandit

## no ruff or flake

90 - isort
80 - black
70 - pycodestyle - no ruff or flake
60 - pyflakes - no ruff or flake

    40 - pyright
    30 - mypy
    20 - pylint

10 - bandit

posix
70 shfmt
50 shellcheck
30 checkbashisms

bash
70 shfmt
50 shellcheck
30 bashate

zsh
70 shfmt
50 shellcheck
zsh-init

## better overall task order

change linter ordering from two groups

file linters
proj linters

into

early linters that are proj linters, should be done before later linters are
done on a file by file basis

Stage 1: mutation tools
isort
black

Stage 2: hard syntax gate (important addition) minimalistic syntax check, for python:
python -m py_compile

faster than most linters
strict
minimal false negatives

Stage 3: structural linters
flake8 (if still used) or ruff in legacy mode (if present)

Stage 4: semantic tools
pyright OR mypy (choose one for coherence)

Stage 5: heuristic tools
vulture bandit pylint

## python order

if no ruff

1. isort - 98
2. black - 96
3. python -m py_compile (or equivalent fast syntax gate) - 90
4. flake8 - 88
5. one of (not both):
   mypy - 35
   pyright - 35
6. vulture
7. bandit - 20
8. pylint - 10

if ruff

1. ruff format - 97
2. python -m py_compile - 90
3. ruff check - 89
4. one of (not both):
   mypy - 35
   pyright - 35
5. vulture - 25
6. bandit - 20

### python

98 isort [if ruff absent / not using "I"] # Sort Python imports automatically
97 ruff-format (ruff formast)
96 black [if no ruff] # Python code formatter
90 py-compile # tests to compile the python code
86 flake8 [if no ruff] # Python linter; handles multiple PEP 8 violations
85/95 ruff # Extremely fast Python linter, written in Rust, when using --fix rewrites code...
70 pycodestyle [if neither ruff/flake8] # PEP 8 style checker; redundant if flake8 is used
60 pyflakes [if neither ruff/flake8] # Passive checker of Python 3 programs
50 mypy # Static type checker for Python
35 pyright [if no mypy] # Static type checker for Python
25 vulture # Python dead code analyzer
20 bandit # Security linter for Python code
10 pylint [if no ruff] # Comprehensive Python code linter

### shell script

90 bash-n # Extremely basic check, should only be enabled if shellcheck is unavailable
85 shfmt # Autoformat shell script source code
50 shellcheck # Linter for shell scripts
30 bashate # Code style enforcement for bash programs
30 checkbashisms # Checks for portability issues in shell scripts

### markdown

70 markdownlint # Linter for Markdown files
70 markdownlint-cli2 # inter for Markdown files
70 pymarkdownlint # Linter for Markdown files

### yaml/ansible

70 yamllint # Linter for YAML files
15 ansible-lint # Checks ansible playbooks for practices and behaviour

### unsorted

90 codespell # Fix common misspellings in source code and text files
70 jsonlint # JSON file linter
70 taplo # TOML toolkit written in Rust
50 cppcheck # Linter for C & C++
50 openrc # Limied OpenRC service script linting via shellcheck
50 rslint # Linter for Rust code
