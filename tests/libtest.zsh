#!/bin/zsh
set -e
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
end() {
	if [[ -n $ZHTTPD_PID ]]; then
		kill $ZHTTPD_PID 2>/dev/null
		wait $ZHTTPD_PID 2>/dev/null
		ZHTTPD_PID=""
	fi
}

