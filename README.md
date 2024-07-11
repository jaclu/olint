# Olint

Olint is a standalone linting tool designed to operate independently of git
cycles. It detects available linting tools and scans the entire file tree,
starting from the current working directory, to process recently changed
files first, regardless of their location.

Ideally suited when examining an already checked out project, or some local
code, not in any repository.

If a file is successfully linted, Olint saves its filename and the time of
its latest change in a cache. On subsequent runs, Olint skips files that
haven't changed.

## Installation

To install Olint, follow these steps:

1. Download the latest release or clone the repository.
2. Run `./deploy` this is used both to install and to update.
3. Execute `olint -c` to list available linters, and install any missing
ones from the supported list that you plan to use.

## Usage

To use Olint, simply run the `olint` command followed by any options or
arguments you want to pass. For example:

```shell
olint 4 -C
```

This command checks files changed in the last 4 hours and continues with the
next file after linting issues are found.

```shell
olint -c
```

This command lists detected linters and filters.

## Supported Linters

Olint supports the following linters out of the box:

- bandit
- checkbashisms
- flake8
- jsonlint
- markdownlint
- pycodestyle
- pylint
- rslint
- shellcheck
- yamllint

Unwanted linters can be excluded, either by simply deleting the plugin file,
or by skipping it in the global or the project config.

If the cmd for a linter is not found, that linter will be skipped.

New linters can be added by creating a definition file in the plugins
folder, located where the global config file is, see below for details.

## Configuration

olint first checks for a configuration file in the base configuration
directory.
If `$XDG_CONFIG_HOME` is defined, olint looks for the configuration file at
`$XDG_CONFIG_HOME/olint/olint.conf`; otherwise, it checks
`~/.config/olint/olint.conf`.

Once this base configuration is parsed, olint examines the local project
configuration file, `.olint.conf`, so this file can override what is in the
global config file.

Here's an example project configuration:

```bash
#!/bin/bash
# This is sourced. Fake bang-path to help editors and linters

# += means that local config is appended to global
#    If global should be replaced, use = instead

skip_plugins+=(
    pycodestyle
    pylint
)

# Explicit excludes, give entire filename as listed by olint
excludes+=(
    services/sshd/ssh_defs/Deb10/etc_init.d_ssh
    #TODO.md
)

# Filter by prefix, as listed by olint
prefixes+=(
    local_tmux_conf/
    .pytest_cache/
)

# Filter by suffix
suffixes+=(
    .md
)

# modify a linter's command line for this project
override_linter_cmd["bandit"]="bandit --skip B101"

#
#  Some options that can be pre-defined
#
# lint_continue=true
# use_cache=false
# debug_level=9

```

## Plugins

For each linter one plugin file must be defined, this should contain
Bash style variable definitions and be saved in the folder `plugins` located
in the same folder as the global config file.

Obligatory: plugin_cmd - what cmd to run

At least one of: plugin_extensions, plugin_file_types must be included,
they are described below.

Sample:

```shell
plugin_cmd="checkbashisms -n -x"
```

When it starts olint checks if it can run the first word in plugin_cmd, if it
is not found, that plugin is ignored.

### Optionals

#### plugin_priority (default is 10)

If multiple plugins can handle the same file, they will be processed starting
with the one with highest priority.

For example shellcheck has higher priority than checkbashisms, since if
a script fails shellcheck, those issues should be addressed first.

If more than one plugin has the same priority, the order is left to olint.

Sample:

```shell
plugin_priority=20
```

#### plugin_extensions

Listing all file extensions the plugin can handle

Sample:

```shell
plugin_extensions=(
    .sh
    .bash
)
```

#### plugin_file_types

Lists all file types the plugin handles, defined as in the output of
`file -b filename`. When processed this is comma-separated, so dont use
the entire output in the definition!

Since some Operating Systems use only lowercase for this, the definitions
are converted to lowercase for comparisons, and thus are case insensitive.
Wildcards can be used.

Sample:

```shell
plugin_file_types=(
    "POSIX shell script*"
    "Bourne-Again shell script*"
)
```

## Cache File

The `.cache.olint` file stores information about already linted files
to optimize olint's performance, each line in the cache file contains the
file's modification time, human readable timestamp, and relative filepath,
This means that after a first run, only changed files will be linted.

## Contributing

Contributions to Olint are welcome! If you find a bug or have a feature
request, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE)
file for details.
