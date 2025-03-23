#!/bin/bash

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Customization scripts source directory
G_SRCDIR=${SCRIPTDIR}/custom

# Input arguments
IN_IP=$1
IN_HOSTNAME=$2

# Check input arguments
if [ -z $IN_IP ] ; then
	echo "[ERROR] No IP of raspberry pi has been specified, aborting"
	exit 1
fi
if [ -z $IN_HOSTNAME ] ; then
	echo "[ERROR] No hostname specified, aborting"
	exit 1
fi

# Check if raspberry is available
echo "[INFO] Checking if IP <$IN_IP> is reachable ..."
OUT=`ping -c 2 $IN_IP`
if [ $? -ne 0 ] ; then
	echo "[ERROR] IP is not reachable <$OUT>, aborting"
	exit 1
fi

echo "[INFO] IP is reachable, checking for SSH access ..."
OUT=`timeout 5 bash -c "</dev/tcp/$IN_IP/22"`
if [ $? -ne 0 ] ; then
	echo "[ERROR] SSH is not available <$OUT>, aborting"
	exit 1
fi

echo "[INFO] SSH access is available, running customization scripts ..."

# Go through all modification scripts and execute them in the proper order
readarray -d '' SCRIPTS < <(find $G_SRCDIR -maxdepth 1 -name "*.sh" -not -name "common.sh" -print0 | sort -Vz)

for SCRIPT in "${SCRIPTS[@]}"
do
        # Get the script file name
        SCRIPT_FILE=$(basename -- $SCRIPT)

        echo "[INFO] ##############################"
        echo "[INFO] Executing script <$SCRIPT_FILE> ..."
        cd ${G_SRCDIR}; bash $SCRIPT_FILE $IN_IP $IN_HOSTNAME
        if [ $? -ne 0 ] ; then
                echo "[ERROR] Failed to execute script, system might be in a intermediate state, aborting"
                exit 1
        else
                echo "[INFO] Script successfully executed"
        fi
        echo "[INFO] ##############################"
done

echo "[INFO] All modification scripts were successfully executed"

exit 0
