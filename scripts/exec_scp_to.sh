#!/bin/bash
# Copy a file via SCP

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Include helper functions
. "${SCRIPTDIR}/common.sh"

# Arguments
IN_IP=$1
IN_DIR_SRC=$2
IN_DIR_DST=$3
IN_SSH_USERNAME=$4
IN_SSH_PASSWORD=$5

# Check arguments
if [ -z $IN_IP ] ; then
	echo "[ERROR] No IP address has been given, aborting"
	exit 1
fi
if [ -z "$IN_DIR_SRC" ] ; then
        echo "[ERROR] No source directory has been given, aborting"
        exit 1
fi
if [ -z "$IN_DIR_DST" ] ; then
        echo "[ERROR] No destination directory has been given, aborting"
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

echo "[INFO] Copying files via SCP <ip=$IN_IP><ssh=$IN_SSH_USERNAME:$IN_SSH_PASSWORD><dirSrc=$IN_DIR_SRC><dirDst=$IN_DIR_DST> ..."

expect $SCRIPTDIR/exec_scp_to.exp $IN_IP $IN_SSH_USERNAME $IN_SSH_PASSWORD "$IN_DIR_SRC" "$IN_DIR_DST"
if [ $? -ne 0 ] ; then
	echo ""
	echo "[ERROR] Executing SSH command failed, aborting"
	exit 1
fi

echo ""
echo "[INFO] Executing SSH command succesful"
exit 0
