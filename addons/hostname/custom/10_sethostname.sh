#!/bin/bash

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Include helper functions
. "${SCRIPTDIR}/common.sh"

# Input arguments
IN_IP=$1
IN_HOSTNAME=$2

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

# Set the new hostname
call_ssh_exec "sudo hostname -b $IN_HOSTNAME"

# Change it in /etc/hostname as well
call_ssh_exec "sudo echo $IN_HOSTNAME | sudo tee /etc/hostname"

# Also change the hostname in /etc/hosts
call_ssh_exec "sudo sed -i '/127.0.1.1.*/d' /etc/hosts"
call_ssh_exec "sudo sed -i '/^127.0.0.1.*/a 127.0.1.1 $IN_HOSTNAME' /etc/hosts"

exit 0
