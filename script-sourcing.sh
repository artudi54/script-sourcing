# Utility functions for dealing with script directories and sourcing.

# Private function to get script directory path. Takes number of entries in a call stack as a parameter.
if [[ -v BASH_VERSION ]]; then
    __script_directory() {
        local num="$1"
        if [[ -z "${BASH_SOURCE[$num]}" ]]; then
            echo "script_directory: not called from script" 1>&2
            return 1
        fi
        local directory="$(dirname "$(readlink -e "${BASH_SOURCE[$num]}")")"
        echo "$directory"
    }
elif [[ -v ZSH_VERSION ]]; then
    __script_directory() {
        local num="$1"
        local file="$(readlink -e "${funcfiletrace[$num]%:*}")"
        if [[ -z "$file" ]]; then
            echo "script_directory: not called from script" 1>&2
            return 1
        fi
        local directory="$(dirname "$file")"
        echo "$directory"
    }
else
    echo "$0: unknown shell, exiting" 1>&2
    return 1
fi

# Public command to get script directory. Works only when called from other script.
script_directory() {
    __script_directory 2
}

# Include command for sourcing files relative to calling script file or absolute path files
include() {
    if [[ "$#" -eq 0 ]]; then
        echo "include: this function takes at least one argument, $# provided" 1>&2
        return 1
    fi
    local file="$1"
    shift

    if [[ "$file" == /* ]] && [[ -f "$file" ]]; then
        source "$file" "$@"
    else
        local dir="$(__script_directory 2 2>/dev/null)"
        local relative="$dir/$file"
        if [[ -f "$relative" ]]; then
            source "$relative" "$@"
        else
            echo "include: no such file: '$file'" 1>&2
            return 2
        fi
    fi
}
