#!/bin/zsh
source libtest.zsh

# Test help options
../zhttpd --port 55432 &!
PID=$!
sleep 1
curl http://localhost:55432/0001.test.zsh
kill $PID
