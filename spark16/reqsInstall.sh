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
    wget https://raw.githubusercontent.com/riseinteractive/shared-scripts/master/spark16/requirements.txt
    /usr/bin/anaconda/bin/pip install -r requirements.txt
    pip install -r requirements.txt
    rm requirements.txt
}

apt_install()
{
    apt-get update
    apt-get install htop vim-nox libjpeg-dev zlib1g-dev libffi-dev g++ librdkafka-dev build-essential libssl-dev python-dev libtiff5-dev libjpeg8-dev zlib1g-dev libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk -y
}

apt_install
pip_install
exit 0
