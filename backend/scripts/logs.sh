#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

LINES="$1"
LINE_COUNT=$(wc -l < "$SCRIPT_DIR/logs.txt")


if [ -z "$LINES" ]; then
    echo "status=error"
    echo "message=Missing argument (number of lines)."
    exit 1
fi

if [ ! -f "$SCRIPT_DIR/logs.txt" ]; then
    echo "status=error"
    echo "message=There is no command in the log file yet."
    exit 1
fi

if [ "$LINE_COUNT" -lt "$LINES" ]; then
    echo "status=error"
    echo "message=There is(are) only $LINE_COUNT command(s) in the log file."
    exit 1
fi

echo "status=ok"
tail -n "$LINES" "$SCRIPT_DIR/logs.txt"
exit 0