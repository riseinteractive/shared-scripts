#!/bin/bash
# Pip Installs!

if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi

pip_install()
{
    pip install numpy
    pip install pykafka
}

pip_install
exit 0