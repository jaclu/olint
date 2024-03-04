# Olint

Still in early development - you have been warned...

The purpose of this linting tool is to work in a standalone fashion,
not depending on git cycles.

It first detects available linting tools, then it scans the entire file tree,
starting at the current working directory, sorting it in reverse chronological
order, in order to process most recently changed files first.
Disregarding what folder they are in.

If a file is succeefully linted, filename and time of its latest change
is saved in a cache.
Next time olint is run files that have not been changed are skipped.

If you only want to monitor files that have been recently changed, give an int
option such as `olint 4` this will only check files changed in the last
4 hours. The cache for files with older time stamps will be maintained.

A config file can be used to define files/folders to be excluded based on
prefix, suffix and by path relative to the project directory,
see an example below.

## Linters supported

- shellcheck
- checkbashisms
- flake8
- vale

echo "checking bash:   $fname"
echo "checking posix:  $fname"
echo "checking python: $fname"
echo "checking vale:   $fname"

## Sample .olint.conf file, defining what to ignore

The first two lines are purely optional

```bash

#!/bin/bash
# This is sourced. Fake bang-path to help editors and linters

#
#  Excludes by prefix/suffix
#
prefixes+=(
    ./.venv/
)
suffixes+=(
    .cfg
    .bas
)

#
#  Specifix excludes, use the file name displayed by olint
#
excludes+=(
    ./tes_db.sqlite
)

#
#  Here cmd path and options passed can be changed.
#  If a linter shouldn't be used set it to skip_this
#
export linter_shellcheck="shellcheck -o all"
export linter_checkbashisms="/odd/path/checkbashisms"
export linter_flake8="/odd/path/flake8"
export linter_vale="skip_this"


```

## .olint.cache

First line defines cache version

The rest of the cache file is one file per line, sorted in reverse
chronological order. That means the most reasently changed file comes first.

Next time olint is run, current mtime is compared with what is in the
cache. If it has not changed, that file is skipped.

each line is: mtime|date|relative filepath
