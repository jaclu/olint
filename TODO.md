# ToDo

## ansible-lint

capture its output if no issues are reported, such as:

ansible-lint  : ansible-for-devops/lamp-infrastructure/playbooks/varnish/templates/default.vcl.j2

```ansible-lint
Passed: 0 failure(s), 0 warning(s) on 1 files. Last profile that met the validation criteria was 'production'.
```

## FileTypes

both the what plugins define and what `file -b filename` outputs should be
piped through `| tr '[:upper:]' '[:lower:]'` to ensure they all are handled
as lowercase. This to avoid the issue with MacOS file command not
being consistent in following the same conventions as Linux.

For example .c files are reported as "c program text" by MacOS and
"C program text" by Linux

always using lowercase seems like a simple solution for this
