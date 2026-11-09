# ToDo

plugin_cmd - check this if available
plugin_cmd_actual - if defined also check this, and use as plugin commandproj_plugin_cmd

investigate in oxlint as oxlint as a much faster alternative than rslint

## Termux

```shell
pip install bandit bashate codespell mypy pycodestyle pyflakes pylint \
    pymarkdownlnt pyright pycodestyle pyflakes
```

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

ruff & flake8
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

## linter candidates to investigate

- ty - newer Python type checker, possible faster alternative to mypy/pyright.
  Check maturity and rule coverage before adopting.
- pyrefly - newer Python type checker, same role as ty. Compare with ty.
- rumdl vs markdownlint-cli2 - current order puts rumdl first, based on speed
  and maintenance claims that haven't been verified yet.

## plugin order

> 200+ - syntax validation, gates the file so nothing modifies code that does not parse
> 199-100 - source-modifying handlers, run in order of priority
> <100 - analysis handlers, all seeing the same final source

Values are a judgment score: faster and lighter tools sit higher, and gaps are
left between neighbours so later additions can fit in.

### Syntax gate

210 py-compile
220 bash-n [skipped if shellcheck is found]

### Python

145 ruff-check - `ruff check --fix` [if ruff_change_code=1]
130 isort
120 ruff-format - `ruff format`
100 black [skipped if ruff-format]
90 ruff-check - `ruff check` [check mode]
85 pyflakes [skipped if ruff-check or flake8]
72 mypy
70 vulture [project linter]
65 pycodestyle [skipped if ruff-check or flake8]
45 bandit
44 flake8 [skipped if ruff-check]
30 pyright [skipped if mypy]
12 pylint [skipped if ruff-check]

### Shell script

160 shfmt - rewrites code [if shfmt_change_code=1]
95 shfmt - check mode [if shfmt_change_code != 1]
80 shellcheck
57 bashate
35 checkbashisms [POSIX shell only]

### Markdown

42 markdownlint-cli2
42 markdownlint [skipped if markdownlint-cli2]
42 pymarkdown [skipped if markdownlint-cli2 or markdownlint]

### YAML and Ansible

60 yamllint
5 ansible-lint [skipped by default]

### TOML

110 taplo-format - `taplo format`
74 taplo-lint - `taplo lint`

### JSON

47 jsonlint

### JavaScript

105 oxlint - `oxlint --fix`

### Other

78 cppcheck [project linter, skipped by default]
55 codespell [project linter]

### sorted by priority

| prio   | plugin            | Descr                                                |
| ------ | ----------------- | ---------------------------------------------------- |
| 220    | bash-n            | Super simple and quick script                        |
| 210    | py-compile        | Syntax validation                                    |
| 160/95 | shfmt             | Autoformat shell script source code                  |
| 145/90 | ruff-check        | `ruff check`                                         |
| 130    | isort             | Checks and formats import statements                 |
| 120    | ruff-format       | `ruff format`                                        |
| 110    | taplo-format      | Formats TOML files                                   |
| 105    | oxlint            | Linter and fixer for JavaScript and TypeScript       |
| 100    | black             | Py code formatter                                    |
| 85     | pyflakes          | Lightweight linting                                  |
| 80     | shellcheck        | Linter for shell scripts                             |
| 78     | cppcheck          | Linter for C & C++ (project only)                    |
| 74     | taplo-lint        | TOML linter                                          |
| 72     | mypy              | Static type checker                                  |
| 70     | vulture           | Dead code finder (py)                                |
| 65     | pycodestyle       | PEP 8 style checker                                  |
| 60     | yamllint          | YAML syntax and style linting                        |
| 57     | bashate           | Code style enforcement for bash programs             |
| 55     | codespell         | Fix common misspellings (project)                    |
| 47     | jsonlint          | JSON file linter                                     |
| 45     | bandit            | Security-focused py linter                           |
| 44     | flake8            | Lightweight tool for enforcing PEP 8                 |
| 42     | markdownlint-cli2 | Linter for Markdown files                            |
| 42     | markdownlint      | Linter for Markdown files                            |
| 42     | pymarkdown        | Python markdown linter                               |
| 35     | checkbashisms     | Check for bashisms in /bin/sh scripts                |
| 30     | pyright           | Static type checker for Python                       |
| 12     | pylint            | Code smells / deeper static analysis                 |
| 5      | ansible-lint      | Checks ansible playbooks for practices and behaviour |
