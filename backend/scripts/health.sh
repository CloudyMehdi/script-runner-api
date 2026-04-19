#!/bin/bash
# Test all scripts

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TEST_COUNT=0


if "$SCRIPT_DIR/ping.sh" "google.com" >/dev/null; then
    echo "Ping test passed!"
    ((TEST_COUNT++))
else
    echo "Ping test failed"
fi



if "$SCRIPT_DIR/print.sh" "Hello, world!" >/dev/null; then
    echo "Print test passed!"
    ((TEST_COUNT++))
else
    echo "Print test failed"
fi




if "$SCRIPT_DIR/logs.sh" 1 >/dev/null; then
    echo "Logs list test passed!"
    ((TEST_COUNT++))
else
    echo "Logs list test failed"
fi



if [ $TEST_COUNT -eq 3 ]; then
    echo "status=200"
    echo "message=All tests passed!"
    exit 0
else
    echo "status=500"
    echo "message=Passed test: $TEST_COUNT/3"
    exit 1
fi