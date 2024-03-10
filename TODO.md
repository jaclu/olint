# TODO.md

## plugin sample

```bash

plugin_name="shellcheck"
plugin_cmd="shellcheck"

# file extentions this plugin handles
plugin_extentions=(
    .sh
    .bash
)

# file-types this plugin handles
plugin_file_types=(
    "*POSIX shell script*"
    "*Bourne-Again shell script*"
)

# # Files this plugin should not handle
# plugin_excludes=(
#     ./tmp/foo.sh
# )

```

linter_cmd[$plugin_name]="$plugin_cmd"
linter_extentions[".sh"]=("supported" "linter")
linter_file_types[$plugin_file_type]=("supported" "linter") # list of plugin_name
linter_excludes[README.md]=(vale)
