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

# Reboot the pi to apply the upgrade
call_ssh_exec "sudo reboot"

# Wait for reboot to complete
REBOOT_TIMEOUT=300
REBOOT_COUNTER=0

echo "[INFO] Waiting for reboot ..."

# Sleep a little bit before checking the first time since the pi might still be reachable via ping
sleep 10

PING_AVAILABLE=0
SSH_AVAILABLE=0

while [ $REBOOT_COUNTER -lt $REBOOT_TIMEOUT ]
do
	# Check if pi is reachable via ping and SSH
	OUT=`ping -c 2 -W 1 $IN_IP`
	if [ $? -eq 0 ] ; then
		echo "[INFO] Raspberry is reachable via ping ..."
		PING_AVAILABLE=1
	else
		echo "[INFO] Waiting for raspberry to be reachable via ping ..."
	fi

	if [ $PING_AVAILABLE -eq 1 ] ; then
		# Check for SSH availability
		OUT=`timeout 5 bash -c "</dev/tcp/$IN_IP/22"`
		if [ $? -eq 0 ] ; then
			echo "[INFO] Raspberry is reachable via SSH ..."
			SSH_AVAILABLE=1
			break
		else
			echo "[INFO] Waiting for raspberry to be reachable via SSH ..."
		fi
	fi

	REBOOT_COUNTER=$((REBOOT_COUNTER+4))
	sleep 2
done

if [ $PING_AVAILABLE -eq 0 ] || [ $SSH_AVAILABLE -eq 0 ] ; then
	echo "[ERROR] Raspberry Pi did not reboot in time, aborting"
	exit 1
fi

echo "[INFO] Raspberry reboot complete"

exit 0
