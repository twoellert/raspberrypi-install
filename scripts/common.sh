#!/bin/bash
# Common settings and helpers

# SSH credentials
G_SSH_USERNAME=pi
G_SSH_PASSWORD=raspberry

# Supporting scripts (BASEDIR is provided by including script)
SSH_EXEC=${BASEDIR}/exec_ssh.sh
SCPTO_EXEC=${BASEDIR}/exec_scp_to.sh

# Generic verify of input arguments
function verify_input_arguments {
        IN_IP=$1

        if [ -z "$IN_IP" ] ; then
                echo "[ERROR] No IP has been provided, aborting"
                return 1
        fi

        return 0
}

# Execute command via SSH
function ssh_exec {
        IN_IP=$1
        IN_CMD=$2
        if [ -z "$IN_IP" ] ; then
                echo "[ERROR] No IP address has been provided, aborting"
                return 1
        fi
        if [ -z "$IN_CMD" ] ; then
                echo "[ERROR] No command to execute has been provided, aborting"
                return 1
        fi
        $SSH_EXEC $IN_IP "$IN_CMD"
        RETVAL=$?
        if [ $RETVAL -ne 0 ] ; then
                echo "[ERROR] Executing command via SSH failed <exitcode=$RETVAL>, aborting"
                return 1
        fi

        return 0
}

# Copy files via SCP
function scp_to_exec {
        IN_IP=$1
        IN_DIR_SRC=$2
        IN_DIR_DST=$3
        if [ -z "$IN_IP" ] ; then
                echo "[ERROR] No IP address has been provided, aborting"
                return 1
        fi
        if [ -z "$IN_DIR_SRC" ] ; then
                echo "[ERROR] No source directory has been provided, aborting"
                return 1
        fi
        if [ -z "$IN_DIR_DST" ] ; then
                echo "[ERROR] No destination directory has been provided, aborting"
                return 1
        fi

        $SCPTO_EXEC $IN_IP "$IN_DIR_SRC" "$IN_DIR_DST"
        RETVAL=$?
        if [ $RETVAL -ne 0 ] ; then
                echo "[ERROR] Copying file via SCP failed <exitcode=$RETVAL>, aborting"
                return 1
        fi

        return 0
}
