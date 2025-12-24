#!/usr/bin/env bash

# Exit on first error.
set -e

# Bash script to clone a hard-coded list of GitHub repositories into a timestamped directory.

# Hard-coded list of repositories (in owner/repo format)
REPOS=(
  # Apps
  "fpgawars/apio"
  "fpgawars/apio-vscode"
  
  # Packages
  "fpgawars/apio-definitions"
  "fpgawars/apio-examples"
  "fpgawars/tools-drivers"
  "fpgawars/tools-graphviz"
  "fpgawars/tools-oss-cad-suite"
  "fpgawars/tools-verible"

  # Helpers
  "fpgawars/apio-workflows"
)

# Generate timestamp with second resolution (e.g., 20251224-153045)
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")

# Create the target directory
TARGET_DIR="apio-repos-${TIMESTAMP}"
mkdir -p "${TARGET_DIR}"
echo "Created directory: ${TARGET_DIR}"

# Change into the target directory
pushd "${TARGET_DIR}" || {
  echo "Error: Failed to enter directory ${TARGET_DIR}"
  exit 1
}

# Clone each repository
for repo in "${REPOS[@]}"; do
  printf "\n--- $repo\n\n"
  url="https://github.com/${repo}.git"
  echo "Cloning ${url} ..."
  git clone "${url}"

done

# Back to parent dir.
popd

# Show cloned sizes
printf "\n---\n\n"
echo "Local repos:"
du -shc "${TARGET_DIR}"/*

echo

# Create an archive file with all repos.
echo "Archive:"
tar -czf "${TARGET_DIR}.tar.gz" "${TARGET_DIR}/"
du -sh "${TARGET_DIR}.tar.gz"

printf "\nDone.\n"
