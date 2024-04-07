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

  local temp_destination="$temp_dir/$target_folder"

  # Create temp_destination if it doesn't exist
  mkdir -p "$temp_destination"

  # Iterate over files in the source directory
  while IFS= read -r -d '' file; do
    if [ -f "$file" ]; then
      # Calculate destination file path
      destination_file="$temp_destination/${file#$target_folder/}"
      mkdir -p "$(dirname "$destination_file")"

      # Perform environment variable substitution
      envsubst <"$file" >"$destination_file"
    fi
  done < <(find "$target_folder" -type f -print0)

  echo "Files copied from $target_folder to $temp_destination with environment variable substitution."
}
export -f copy_and_substitute

# Main function
main() {
  # Validate input parameters
  if [ "$#" -lt 2 ]; then
    echo "Usage: opkustomize <env_file> <target_folder> [other_flags...]"
    exit 1
  fi

  local env_file="$1"
  local target_folder="$2"
  shift 2 # Shift to ignore the first two arguments

  # Create temporary directory
  local root=$(dirname "${BASH_SOURCE[0]}")
  temp_dir=$(mktemp -d "${root}/tmp.XXXXXXXXX")
  # Run main functionality
  op run --env-file="$env_file" -- bash -c 'copy_and_substitute "$0" "$1"' "$target_folder" "$temp_dir"
  kustomize build "$temp_dir/$target_folder" "$@"
}

# Call main function with provided arguments
main "$@"