#!/bin/bash
path="./ffmpeg-darwin-x64"
# path=$1
echo "Checking Gatekeeper status"
spctl --status
echo "Assessing ${path}"
spctl --assess --verbose "${path}"
echo "Assessing type execute ${path}"
spctl --assess --type execute --verbose "${path}"
echo "Checking Gatekeeper done for ${path}"

label="ffmpeg-helper"
# Run the spctl command and capture the output
output=$(spctl --list --label "${label}" 2>&1)
# Check the command output to determine if the label is allowed to run
if [[ "${output}" == *allow* ]]; then
    echo "The label '${label}' is allowed to run according to spctl."
else
    echo "The label '${label}' is not allowed to run according to spctl."
    echo "output: ${output}"
fi

# check if the file has been stapled
if stapler validate "${path}" &> /dev/null; then
  echo "File has been stapled"
else
  echo "File has not been stapled"
  stapler validate "${path}"
fi
