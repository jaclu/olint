# Olint

Olint is a standalone linting tool designed to operate independently of git cycles. It detects available linting tools and scans the entire file tree, starting from the current working directory, to process recently changed files first, regardless of their location.

If a file is successfully linted, Olint saves its filename and the time of its latest change in a cache. On subsequent runs, Olint skips files that haven't changed.

## Installation

To install Olint, follow these steps:

1. [Download](#) the latest release or clone the repository.
2. Run ./deploy
3. Install any missing linters that you intend to use.

## Usage

To use Olint, simply run the `olint` command followed by any options or arguments you want to pass. For example:

```shell
olint -c 4
```

This command checks files changed in the last 4 hours and continues with the next file after linting issues are found.

```shell
olint -l
```

This command lists detected linters and displays any default options used. You can override this in a per project .olint.conf file (see below).

## Supported Linters

Olint supports the following linters out of the box:

- shellcheck
- checkbashisms
- flake8
- vale

## Configuration

You can customize Olint's behavior using a `.olint.conf` file. Here's an example configuration:

```bash
#!/bin/bash
# This is sourced. Fake bang-path to help editors and linters

# Excludes by prefix/suffix
prefixes+=(
    ./.venv/
)
suffixes+=(
    .cfg
    .bas
)

# Specific excludes, use the file name displayed by Olint
excludes+=(
    ./tes_db.sqlite
)

# Define linter commands and options, if you wan't to override the defaults.
# "skip_this" is a special case and means that this linter will not be used.
export linter_shellcheck="shellcheck -o all"
export linter_checkbashisms="/odd/path/checkbashisms"
export linter_flake8="/odd/path/flake8"
export linter_vale="skip_this"
```

## .olint.cache

The `.olint.cache` file stores information about recently changed files
to optimize Olint's performance, each line in the cache file contains the file's modification time, date,
and relative filepath, sorted in reverse chronological order.

## Contributing

Contributions to Olint are welcome! If you find a bug or have a feature request, please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
