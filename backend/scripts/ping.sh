#!/bin/bash

HOST="$1"

# DNS test
if ! getent hosts "$HOST" >/dev/null 2>&1; then
    echo "status=error"
    echo "message=DNS error. The domain name is probably incorrect."
    exit 1
fi

# TCP test (80 or 443)
PORT=80
timeout 5 bash -c "</dev/tcp/$HOST/$PORT" >/dev/null 2>&1
TCP_RET=$?

# HTTP test
HTTP_OUTPUT=$(curl -s -o /dev/null -w "%{http_code} %{time_total}" "http://$HOST")
HTTP_CODE=$(echo "$HTTP_OUTPUT" | awk '{print $1}')
HTTP_TIME=$(echo "$HTTP_OUTPUT" | awk '{print $2}')

# If HTTP does not work, try HTTPS
if [ "$HTTP_CODE" = "000" ]; then
    HTTP_OUTPUT=$(curl -s -k -o /dev/null -w "%{http_code} %{time_total}" "https://$HOST")
    HTTP_CODE=$(echo "$HTTP_OUTPUT" | awk '{print $1}')
    HTTP_TIME=$(echo "$HTTP_OUTPUT" | awk '{print $2}')
    PROTOCOL="HTTPS"
else
    PROTOCOL="HTTP"
fi


# TCP fail
if [ "$TCP_RET" -ne 0 ]; then
    echo "status=error"
    echo "message=TCP connection failed"
    exit 2
fi

# HTTP unreachable
if [ "$HTTP_CODE" = "000" ]; then
    echo "status=error"
    echo "message=No HTTP response"
    exit 3
fi

# HTTP error
if [ "$HTTP_CODE" -ge 400 ]; then
    echo "status=error"
    echo "message=HTTP error $HTTP_CODE"
    exit 4
fi


# SUCCESS
echo "status=ok"
echo "message=$PROTOCOL OK ($HTTP_CODE) in ${HTTP_TIME}s"
exit 0