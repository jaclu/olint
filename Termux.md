# Termuux suggestions

Termux still allows global pip installs, so no venv is necessary

Several plugins are only available as pips, so below is a suggested
plugin install procedure

recommended: `pip install pip-autoremove` and then use `pip-autoremove bandit`
to remove dependencies

```sh

apt install ruff cppcheck shellcheck
# pycodestyle pyflakes3 pylint 

apt install nodejs npm
npm install -g jsonlint
# check installed using: npm list -g --depth=0


# shellcheck 0.11.0

pip install bandit bashate codespell pymarkdown mypy pycodestyle pyflakes \
    pylint pymarkdownlnt yamllint




```
