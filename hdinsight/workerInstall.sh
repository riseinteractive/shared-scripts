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

#for some reason python perms need to get reset
python_perms()
{
    chmod 755  /usr/local/lib/python2.7 -R
}

pip_install
python_perms
exit 0