#!/bin/bash
# Helper functions

# Get script directory
SCRIPTDIR=$(dirname $(readlink -f $0))

# Base helper dir
BASEDIR="${SCRIPTDIR}/../../scripts"

# Include base helpers
. "${BASEDIR}/common.sh"
