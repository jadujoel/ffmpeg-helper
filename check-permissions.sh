#!/bin/bash
source paths.sh
# loop through all paths
for path in "${paths[@]}"; do
  # check if the file exists
  if [[ ! -f "${path}" ]]; then
    echo "File not found: ${path}"
    continue
  fi

  # check if the user has execute permission
  if [[ ! -x "${path}" ]]; then
    echo "Permission denied: ${path}"
    continue
  fi

  echo "Permission granted: ${path}"
done
