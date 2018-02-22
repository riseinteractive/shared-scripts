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
    wget https://raw.githubusercontent.com/riseinteractive/shared-scripts/master/spark22/requirements.txt
    /usr/bin/anaconda/bin/pip install oauth oauth2client==1.5.2
    /usr/bin/anaconda/bin/pip install -r requirements.txt
    pip install oauth oauth2client==1.5.2
    pip install -r requirements.txt
    rm requirements.txt
}

pip_install
exit 0