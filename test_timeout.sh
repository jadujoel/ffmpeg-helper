#!/bin/bash

# 1. Command finishes before timeout.
result=$(./timeout.sh 5 echo "Hello World") > /dev/null 2>&1
exit_status=$?
expected="Hello World
Command succeeded."
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 1: PASSED - Expected '${expected}'"
else
  echo "Test 1: FAILED - Expected '${expected}' but got '${result}'"
fi

expected=0
result=${exit_status}
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 1: PASSED - Expected '${expected}'"
else
  echo "Test 1: FAILED - Expected exit code '${expected}' but got '${result}'"
fi

# 2. Command exceeds timeout.
result=$(./timeout.sh 2 sleep 5)
exit_status=$?
expected="Timeout occurred after 2 seconds."
if [[ "${result}" == "${expected}" ]] && [[ "${exit_status}" -eq 124 ]]; then
  echo "Test 2: PASSED - Expected '${expected}'"
else
  echo "Test 2: FAILED - Expected '${expected}' but got '${result}'"
fi

expected=124
result=${exit_status}
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 2: PASSED - Expected '${expected}'"
else
  echo "Test 2: FAILED - Expected exit code '${expected}' but got '${result}'"
fi

# 3. Command fails with an error.
result=$(./timeout.sh 5 non-existent-command)
exit_status=$?
expected="Command failed with exit code 127."
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 3: PASSED - Expected '${expected}'"
else
  echo "Test 3: FAILED - Expected '${expected}' but got '${result}'"
fi

expected=127
result=${exit_status}
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 3: PASSED - Expected '${expected}'"
else
  echo "Test 3: FAILED - Expected exit code '${expected}' but got '${result}'"
fi

# 4. Another Command fails with an error.
result=$(./timeout.sh 5 ls -l /non-existent-dir)
exit_status=$?
expected="Command failed with exit code 2."
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 4: PASSED - Expected '${expected}'"
else
  echo "Test 4: FAILED - Expected '${expected}' but got '${result}'"
fi

expected=2
result=${exit_status}
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 4: PASSED - Expected '${expected}'"
else
  echo "Test 4: FAILED - Expected exit code '${expected}' but got '${result}'"
fi


# 5. Invalid input to the script.
result=$(./timeout.sh)
exit_status=$?
expected="Usage: ./timeout.sh <timeout-in-seconds> <command> [args...]"
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 5: PASSED - Expected '${expected}'"
else
  echo "Test 5: FAILED - Expected '${expected}' but got '${result}'"
fi

expected=1
result=${exit_status}
if [[ "${result}" == "${expected}" ]]; then
  echo "Test 5: PASSED - Expected '${expected}'"
else
  echo "Test 5: FAILED - Expected exit code '${expected}' but got '${result}'"
fi
