#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

SCRIPT="$1"
SUCCESS="$2"
OPTION1="$3"

if [ "$SCRIPT" = "health" ]; then
    if [ "$SUCCESS" -eq 0 ]; then
        echo "$(LC_ALL=C date): Health check passed!" >> "$SCRIPT_DIR/logs.txt"
    else
        echo "$(LC_ALL=C date): Health check failed!" >> "$SCRIPT_DIR/logs.txt"
    fi
fi

if [ "$SCRIPT" = "ping" ]; then
    if [ "$SUCCESS" -eq 0 ]; then
        echo "$(LC_ALL=C date): Ping $OPTION1!" >> "$SCRIPT_DIR/logs.txt"
    elif [ "$SUCCESS" -eq 1 ]; then
        echo "$(LC_ALL=C date): DNS error during ping $OPTION1 execution!" >> "$SCRIPT_DIR/logs.txt"
    elif [ "$SUCCESS" -eq 2 ]; then
        echo "$(LC_ALL=C date): TCP connection failed to $OPTION1 during ping execution!" >> "$SCRIPT_DIR/logs.txt"
    elif [ "$SUCCESS" -eq 3 ]; then
        echo "$(LC_ALL=C date): no responses during ping $OPTION1 execution!"
    else
        echo "$(LC_ALL=C date): HTTP error during ping $OPTION1 execution!" >> "$SCRIPT_DIR/logs.txt"
    fi
fi

if [ "$SCRIPT" = "logs" ]; then
    if [ "$SUCCESS" -eq 0 ]; then
        echo "$(LC_ALL=C date): Logs list: $OPTION1" >> "$SCRIPT_DIR/logs.txt"
    else
        echo "$(LC_ALL=C date): Error during logs list execution! $OPTION1 lines" >> "$SCRIPT_DIR/logs.txt"
    fi
fi

if [ "$SCRIPT" = "print" ]; then
    if [ "$SUCCESS" -eq 0 ]; then
        echo "$(LC_ALL=C date): Print: $OPTION1" >> "$SCRIPT_DIR/logs.txt"
    else
        echo "$(LC_ALL=C date): Error during print execution!" >> "$SCRIPT_DIR/logs.txt"
    fi
fi