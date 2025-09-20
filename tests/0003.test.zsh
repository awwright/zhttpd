#!/bin/zsh
exit 0;
source libtest.zsh

# Test HTTP server receiving requests from hub
arbitrary_http_port=$(random_unused_port)
arbitrary_hub_port=$(random_unused_port)
zsh simplehub.zsh $arbitrary_http_port $arbitrary_hub_port &!
HUB_PID=$!
../zhttpd --hub $arbitrary_hub_port >/dev/null &!
HTTPD_PID=$!

# Very short sleep to let the TCP port register
# Ideally I'd wait for some sort of event or feedback from the process itself
sleep 0.1
curl http://localhost:$arbitrary_http_port/0003.test.zsh -s -o /dev/null
kill $HUB_PID $HTTPD_PID
