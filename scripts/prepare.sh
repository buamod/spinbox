#!/usr/bin/env bash
 
set -e
 
#
# Executes a command and (exponentially) retries if it fails.
#
# Usage:
#
#   exec_with_retry <command>
#
# Example:
#
#   exec_with_retry ls path/that/does/not/exist
#
# https://jonlabelle.com/snippets/view/shell/execute-command-with-exponential-retry-in-bash
#
 
exp(){
readonly SCRIPT_NAME=$(basename "${0}")
readonly CMD_NAME="${SCRIPT_NAME%.*}"
 
log_error() {
    printf "%b\n" "[$CMD_NAME error] $1" >&2
}
 
log_info() {
    printf "%b\n" "[$CMD_NAME] $1" >&2
}
 
show_usage() {
    echo "Executes a command and (exponentially) retries if it fails."
    echo "Usage: ${CMD_NAME} <command_and_args_to_execute>"
}
 
main() {
    if [[ "$1" = "-h" || "$1" = "--help" || "$1" = "help" || "$1" = "--version"  ]]; then
        show_usage
        exit 2
    fi
 
    local retries wait_factor count status_code sleep_seconds
 
    retries=20
    wait_factor=3
    count=0
 
    until "$@"; do
        status_code=$?
        count=$((count + 1))
        if [ $count -lt $retries ]; then
            sleep_seconds=$((wait_factor ** (count - 1)))
            log_info "Retry $count/$retries exited with status code $status_code, retrying in $sleep_seconds seconds..."
            sleep $sleep_seconds
        else
            log_error "Retry $count/$retries exited with status code $status_code. No more retries left."
            return $status_code
        fi
    done
 
    return 0
}
 
if [ "$#" -eq 0 ]; then
    show_usage
    exit 1
else
    main $*
fi
}
echo "Prepare host"
exp sudo hal
