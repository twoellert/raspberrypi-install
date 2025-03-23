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

# Disable PAM authentication in SSHD, causes a slot SSH login
call_ssh_exec "sudo sed -i 's/UsePAM.*/UsePAM no/g' /etc/ssh/sshd_config"

call_ssh_exec "sudo systemctl restart sshd"

exit 0
