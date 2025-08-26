#!/bin/sh
# Print all environment variables
printf "Content-Type: text/plain\r\n"
printf "Status: 200\r\n"
printf "\r\n"
env
printf "\r\n"
