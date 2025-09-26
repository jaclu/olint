# ToDo

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
- rslint  ignores ctrl c

## Linter pips

bandit
flake8
jsonlint
pycodestyle
pylint
yamllint
