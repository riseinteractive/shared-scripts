#!/bin/bash
# Pip Installs! 1.6 version

if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi

/sbin/shutdown -r -t 5

exit 0
