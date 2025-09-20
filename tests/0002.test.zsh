#!/bin/zsh
source libtest.zsh

# Test HTTP server on TCP port
arbitrary_port=$(random_unused_port)
../zhttpd --port $arbitrary_port >/dev/null &!
PID=$!
# Very short sleep to let the TCP port register
# Ideally I'd wait for some sort of event or feedback from the process itself
sleep 0.1
curl http://localhost:$arbitrary_port/0002.test.zsh -s -o /dev/null
kill $PID
