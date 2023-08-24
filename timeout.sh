#!/bin/bash
set -u

usage() {
  echo "Usage: $0 <timeout-in-seconds> <command> [args...]"
}

if [[ $# -lt 2 ]]; then
  usage
  exit 1
fi

TIMEOUT=$1
shift

"$@" &
CMD_PID=$!

# Wait a bit to allow the command to start and possibly fail.
sleep 0.1

# If the command is not running, get its exit status immediately.
if ! ps -p "${CMD_PID}" > /dev/null; then
    wait "${CMD_PID}" 2>/dev/null
    CMD_EXIT_STATUS=$?
    if [[ ${CMD_EXIT_STATUS} -ne 0 ]]; then
      echo "Command failed with exit code ${CMD_EXIT_STATUS}."
      exit "${CMD_EXIT_STATUS}"
    else
      echo "Command succeeded."
      exit 0
    fi
fi

# If we get here, the command is still running, and we start the timeout countdown.
elapsed_time=0
while [[ ${elapsed_time} -lt ${TIMEOUT} ]]; do
  sleep 1
  if ! ps -p "${CMD_PID}" > /dev/null; then
    # Command has finished, capture its exit status
    wait "${CMD_PID}" 2>/dev/null
    CMD_EXIT_STATUS=$?
    if [[ ${CMD_EXIT_STATUS} -ne 0 ]]; then
      echo "Command failed with exit code ${CMD_EXIT_STATUS}."
      exit "${CMD_EXIT_STATUS}"
    else
      echo "Command succeeded."
      exit 0
    fi
  fi
  ((elapsed_time++))
done

# If we reach this point, the command is still running and has timed out
kill -TERM "${CMD_PID}" 2>/dev/null
echo "Timeout occurred after ${TIMEOUT} seconds."
exit 124
