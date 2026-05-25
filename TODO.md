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

1. isort
2. black
3. python -m py_compile   (or equivalent fast syntax gate)
4. flake8
5. pyright  (or mypy, not both ideally)
6. vulture
7. bandit
8. pylint

if ruff

1. ruff format
2. python -m py_compile
3. ruff check
4. pyright (or mypy, not both)
5. vulture
6. bandit
