#!/bin/bash
# Pip Installs! 1.6 version

if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi

pip_install()
{
    wget 
    pip install numpy
    pip install pykafka
}

apt_install()
{
    apt-get update && apt-get dist-upgrade -y
    apt-get install htop vim-nox
}

pip_install
apt_install
exit 0