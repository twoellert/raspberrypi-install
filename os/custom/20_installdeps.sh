#!/bin/bash

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Include helper functions
. "${SCRIPTDIR}/common.sh"

# Input arguments
IN_IP=$1

verify_input_arguments $IN_IP
if [ $? -ne 0 ] ; then
	echo "[ERROR] Input argument verification failed <ip=$IN_IP>, aborting"
	exit 1
fi

# Set functions for easy access
function call_ssh_exec {
	ssh_exec $IN_IP "$1"
	if [ $? -ne 0 ] ; then
		exit 1
	fi
}

#############################################
# MODIFICATIONS OF IMAGE START HERE
#############################################

# Update list of packages
call_ssh_exec "sudo apt update"

# Install additional packages
call_ssh_exec "sudo apt install -y vim net-tools snapd"

# Disable apparmor which gets installed together with snapd
call_ssh_exec "sudo systemctl disable apparmor"

exit 0
