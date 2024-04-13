#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

# Function to perform cleanup
cleanup() {
  if [ -n "${temp_dir-}" ] && [ -d "$temp_dir" ]; then
    rm -rf "$temp_dir"
  fi
}

# Function to handle pre-exit actions
pre_exit() {
  echo
  echo 'Exiting with exception...'
  cleanup
  exit 1
}

# Trap signals for cleanup
trap cleanup EXIT
trap pre_exit HUP INT QUIT TERM

# Function to copy files and perform environment variable substitution
copy_and_substitute() {
  local target_folder="$1"
  local temp_dir="$2"
  local dry_run="$3"

  local temp_destination="$temp_dir"

  local root_path
  root_path="$target_folder"

  IFS='/' read -ra parts <<< "$target_folder"
  if [ "${parts[0]}" = "." ]; then
      root_path="${parts[1]}"
  else
    root_path="${parts[0]}"
  fi


  # Create temp_destination if it doesn't exist
  mkdir -p "$temp_destination/$root_path"

  # Copy everything from the source root directory to the temp destination
  # We copy everything from the root to be able to apply overlays too
  cp -r "$root_path"/* "$temp_destination/$root_path"

  # Perform environment variable substitution
  if [ "$dry_run" = false ]; then
    find "$temp_destination" -type f -exec envsubst {} \;
  fi
}

export -f copy_and_substitute

display_usage() {
  echo "Usage: opkustomize <env_file> <target_folder> [other_flags...]"
}

# Function to validate arguments being passed in
validateArguments() {
  if [ "$#" -eq 0 ] || [ "$1" == "help" ]; then
    display_usage
    exit 0
  fi

  # Validate input parameters
  if [ "$#" -lt 2 ]; then
    display_usage
    exit 1
  fi

}

# Main function
main() {

  validateArguments "$@"

  local dry_run

  dry_run="${dry_run:-false}"

  for arg; do
    shift
    case $arg in
    --dry-run)
      dry_run=true
      ;;
    *) set -- "$@" "$arg" ;;
    esac
  done

  local env_file="$1"
  local target_folder="$2"
  shift 2 # Shift to ignore the first two arguments

  local root
  root=$(dirname "${BASH_SOURCE[0]}")

  # Create temporary directory
  temp_dir=$(mktemp -d "${root}/tmp.XXXXXXXXX")

  # Run main functionality
  if [ "$dry_run" = false ]; then
    op run --env-file="$env_file" -- bash -c 'copy_and_substitute "$0" "$1"' "$target_folder" "$temp_dir"
  else
    copy_and_substitute "$target_folder" "$temp_dir" "$dry_run"
  fi

  kustomize build "$temp_dir/$target_folder" "$@"
}

# Call main function with provided arguments
main "$@"
