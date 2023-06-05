label="ffmpeg-helper"

# Run the spctl command and capture the output
output=$(spctl --list --label "${label}" 2>&1)
echo "output: ${output}"
# Check the command output to determine if the label is allowed to run
if [[ "${output}" == *allow* ]]; then
    echo "The label '${label}' is allowed to run."
else
    echo "The label '${label}' is not allowed to run."
fi
