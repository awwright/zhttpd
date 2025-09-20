#!/bin/zsh
# This script opens two ports and waits for a connection to each port, then forwards the data between each connection.
# Check that exactly two port numbers are provided
if [[ $# -ne 2 ]]; then
	echo "Usage: $0 <port1> <port2>"
	exit 1
fi

# Validate port numbers
if ! [[ $1 =~ '^[0-9]+$' && $2 =~ '^[0-9]+$' ]]; then
	echo "Error: Ports must be valid numbers"
	exit 1
fi

port1=$1
port2=$2

# Load ztcp module
zmodload zsh/net/tcp
zmodload zsh/system

# Open TCP listeners on both ports
ztcp -l $port1
fd1=$REPLY
ztcp -l $port2
fd2=$REPLY

# Function to handle connection and forward data
forward_data() {
	local from_fd=$1
	local to_fd=$2
    while sysread -c count -i $from_fd -o $to_fd; do
        : # Continue forwarding
    done
    if [[ $count -eq 0 ]]; then
        # Close both connections if one side closes
        ztcp -c $from_fd $to_fd
        exit
    fi
}

# Accept one connection on each port
ztcp -a $fd1
client1=$REPLY
ztcp -a $fd2
client2=$REPLY

# Forward data in both directions
forward_data $client1 $client2 &!
forward_data $client2 $client1 &!

# Wait for background processes to finish
wait

# Cleanup
ztcp -c $fd1 $fd2 $client1 $client2
