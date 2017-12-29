#!/bin/sh

PID_FILE="~/.offlineimap/pid"

pid=$(echo $PID_FILE)

# Do not run offlineimap if an instance is already running
if [ -z $pid ]; then
  ps $pid 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Offlineimap already running."
    exit 1
  fi
fi

# Run offlineimap and store its pid
offlineimap -u quiet &
echo $! > $PID_FILE


