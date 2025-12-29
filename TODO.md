# ToDo

## order for shell check

Shoulddn't bashate go before shellcheck?

## pyflakes

supposedly redundant if flake8 is found, however flake8 seems unable
to find `#hepp` without complaining about missing space

## Dont list files covered by project linters as `No linter`

## order project linter by prio

initially just use the existing prio variable

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
