#!/bin/bash

# MacOS Only script
# This script verifies that the ffmpeg-helper binary is codesigned correctly and has the correct permissions.
# It also tries to run the binary to make sure it works.
# This is useful for CI/CD pipelines to make sure the binary is working correctly.
# Especially for MacOS Ventura where we have had some issues sporadically with the ffmpeg binary not being able to run.
# Until it's been run once manually.

set -u
echo "Running Tests for ffmpeg-helper"

os=$(uname)
# check what OS we are on
if [[ "${os}" != "Darwin" ]]; then
    echo "This script is only needed for MacOS"
    echo "Exiting..."
    exit 0
fi

# check if using x64 or arm64
arch=$(uname -m)
name="ffmpeg-darwin-x64"
if [[ ${arch} == "x86_64" ]]; then
    echo "Arch: x64 (intel)"
    name="ffmpeg-darwin-x64"
elif [[ ${arch} == "arm64" ]]; then
    echo "Arch: arm64 (apple silicon)"
    name="ffmpeg-darwin-arm64"
else
    echo "Unsupported Architecture, ${arch}"
    exit 1
fi

here_relative=$(dirname "${0}")
here=$(realpath "${here_relative}")
file=$(realpath "${here}/${name}.app/Contents/MacOS/${name}")
checkmark="\xE2\x9C\x93"
cross="\xE2\x9D\x8C"
timeout_script="${here}/timeout.sh"

echo "File: ${file}"

# Check that file exists
if [[ ! -f "${file}" ]]; then
    echo "File does not exist."
    echo "Make sure you have installed the ffmpeg-helper package. (npm install ffmpeg-helper)"
    echo "Exiting..."
    exit 1
fi

# Check that timeout script exists
if [[ ! -f "${timeout_script}" ]]; then
    echo "Timeout script does not exist."
    echo "Cannot run test without it."
    echo "Exiting..."
    exit 1
fi

if ! codesign=$(spctl --assess --verbose "${file}" 2>&1); then
    echo "File is not Codesigned correctly."
    echo "Result: ${codesign}"
    echo "Exiting..."
    exit 1
fi
echo -e "Codesigned ${checkmark}"
# check permissions
if [[ -x "${file}" ]]; then
    echo -e "Permissions ${checkmark}"
else
    echo "File Is Not Executable"
    echo "Exiting..."
    exit 1
fi


## Try to run the executable
echo "Execution..."
result=$("${timeout_script}" 8 "${file}" -hide_banner -version 2>&1)

exit_code=$?

# if the output includes "ffmpeg version" then it worked
if [[ ${exit_code} -ne 0 ]]; then
    echo -e "Running the executable failed ${cross}"
    echo "Result: ${result}"
    echo "Exit Code: ${exit_code}"
    echo "Try double clicking the file to make sure it works."
    echo "Exiting..."
    exit 1
elif [[ ${result} != *"ffmpeg version"* ]]; then
    echo -e "Running the executable failed ${cross}"
    echo "Result: ${result}"
    echo "Result did not include 'ffmpeg version'"
    echo "Try double clicking the file to make sure it works."
    echo "Exiting..."
    exit 1
fi
echo -e "Execution worked ${checkmark}"

echo "Encoding..."
infile=$(realpath "${here}/test.wav")
# Cannot use realpath because it will fail if the file does not exist."
outfile="${here}/test.mp3"


rm -f "${outfile}"
cmd="${file} -hide_banner -i \"${infile}\" -y \"${outfile}\""
encoding=$(eval "${cmd}" 2>&1)
exit_code=$?
if [[ ${exit_code} -ne 0 ]]; then
    echo -e "Encoding failed ${cross}"
    echo "Result: ${encoding}"
    echo "Exit Code: ${exit_code}"
    echo "Exiting..."
    exit 1
fi
# check if outfile exists
if [[ ! -f "${outfile}" ]]; then
    echo -e "Encoding failed ${cross}"
    echo "Result: ${encoding}"
    echo "Exiting..."
    exit 1
else
    echo -e "Encoding worked ${checkmark}"
fi
echo -e "All checks passed ${checkmark}"
