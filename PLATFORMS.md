# Platform types

## iOS

apk add codespell cppcheck flake8 taplo yamllint
pip install bandit bashate black pymarkdownlnt vulture

not available (outside edge): shellcheck
not working: jsonlint pyright ruff shfmt
skipped too slow: bashate checkbashisms mypy pylint pylintrc

## Termux

apt install cppcheck ruff shellcheck shfmt taplo
pip install bandit bashate codespell pymarkdownlnt pyright vulture yamllint
npm install -g jsonlint

### Manual

- checkbashisms - copy perl script from other node

### Not used atm

pip install black flake8 isort mypy pycodestyle pyflakes pylint

### Unavailable

markdownlint markdownlint-cli2 rslint
