#!/bin/zsh
source libtest.zsh

# Test help options
../zhttpd --help | grep Options > /dev/null
../zhttpd '-?' | grep Options > /dev/null
