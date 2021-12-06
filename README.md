# Script sourcing
This shell library provides utilites for sourcing scripts in larger bash or zsh codebases.

## Provided functions

### Script Directory
`script_directory` is a zero argument function that returns the directory of the calling script file. It works only when called from the script, it won't work when calling from shell

Example:
```bash
local scriptDir="$(script_directory)"
echo "$scriptDir"
```

### Include
`include` is a wrapper function for `source` builtin. It provides an alternative to `source` command, letting calling script to source another in two ways:

- by script's absolute path
- by script's path relative to calling script

Optionally it can take more than one argument and these arguments will be passed to the sourced script.

Example:
```bash
include "/absoulte/path/script.sh"
include "relative/path/script.sh"
include "script.sh" -f file.txt # optional arguments to pass to 'script.sh'
```

## Compatibility
These two functions will work both in zsh and bash environments. `script_directory` function, which is also used is `include`, provides two versions - one for bash and one for zsh. 

During the source process, based on `BASH_VERSION` and `ZSH_VERSION` environment variables, the version corresponding to the current shell will be selected. If the shell interpreter cannot be determined, the source process will stop and error will be printed on the screen.

## How to use this library
In your bash/zsh codebase at the very beginning add:
```bash
source "/path/to/script-sourcing/script-sourcing.sh"
```

If source-scripting directory is relative to the executed script, then you can get script directory and source the file this way:
```bash
if [ -n "$BASH_VERSION" ]; then
    dir="$(dirname "$BASH_SOURCE")"
elif [ -n "$ZSH_VERSION" ]; then
    dir="$(dirname "${(%):-%N}")"
fi
source "$dir/path/to/script-sourcing/script-sourcing.sh"
```

After sourcing the library, you can start using `include` and `script_directory`, and forget about `source` limitations completely.
