#!/bin/zsh

# Exit if any command fails
set -e

# Kill all child processes of the current script
cleanup() {
    pkill -P $$ 2>/dev/null || true
}
trap cleanup EXIT
trap cleanup INT

start() {
	# Start zhttpd as coprocess
	coproc ./zhttpd
	ZHTTPD_PID=$!

	# Wait for the "Now listening on [number]" message, forwarding output to stdout
	local port=""
	local start_time=$(date +%s)
	local timeout=10

	while true; do
		if ! read -p line; then
			echo "Error: Coprocess ended unexpectedly"
			kill $ZHTTPD_PID 2>/dev/null
			return 1
		fi

		# Forward the line to stdout
		print -r -- $line

		# Check for timeout
		local current_time=$(date +%s)
		if (( current_time - start_time > timeout )); then
			echo "Error: zhttpd did not start within $timeout seconds"
			kill $ZHTTPD_PID 2>/dev/null
			return 1
		fi

		# Check if the line matches the pattern
		if [[ $line =~ "Now listening on ([0-9]+)" ]]; then
			port=${match[1]}
			break
		fi
	done

	# Start forwarding the remaining output in the background
	{
		while read -p line; do
			print -r -- $line
		done
	} &

	# Return the port
	echo $port
}

# Function to end the zhttpd coprocess
stop() {
	if [[ -n $ZHTTPD_PID ]]; then
		kill $ZHTTPD_PID 2>/dev/null
		wait $ZHTTPD_PID 2>/dev/null
		ZHTTPD_PID=""
	fi
}

# To test opening a port on a specific port number,
# try our best to find an unused port number
random_unused_port() {
	local port
	for i in 0...20; do
		port=$(( ( RANDOM % (65535 - 1024 + 1) ) + 1024 ))
		lsof -iTCP -sTCP:LISTEN -n -P | grep --color=never ":$port" || echo $port
	done
}
