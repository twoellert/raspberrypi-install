#!/bin/bash
# Execute command via SSH

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Include helper functions
. "${SCRIPTDIR}/common.sh"

# Arguments
IN_IP=$1
IN_CMD=$2
IN_SSH_USERNAME=$3
IN_SSH_PASSWORD=$4

# Check arguments
if [ -z $IN_IP ] ; then
	echo "[ERROR] No IP address has been given, aborting"
	exit 1
fi
if [ -z "$IN_CMD" ] ; then
        echo "[ERROR] No SSH command to execute has been given, aborting"
        exit 1
fi
if [ -z $IN_SSH_USERNAME ] ; then
	# Use default settings
	IN_SSH_USERNAME=$G_SSH_USERNAME
fi
if [ -z $IN_SSH_PASSWORD ] ; then
	# Use default settings
	IN_SSH_PASSWORD=$G_SSH_PASSWORD
fi

echo "[INFO] Executing SSH command <ip=$IN_IP><ssh=$IN_SSH_USERNAME:$IN_SSH_PASSWORD><cmd=$IN_CMD> ..."

export LC_ALL="en_GB.UTF-8"
expect $SCRIPTDIR/exec_ssh.exp $IN_IP $IN_SSH_USERNAME $IN_SSH_PASSWORD "$IN_CMD"
if [ $? -ne 0 ] ; then
	echo ""
	echo "[ERROR] Executing SSH command failed, aborting"
	exit 1
fi

echo ""
echo "[INFO] Executing SSH command succesful"
exit 0
