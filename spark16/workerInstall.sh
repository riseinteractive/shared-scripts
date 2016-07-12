#!/bin/bash
# Pip Installs! 1.6 version

if [ "${UID}" -ne 0 ];
then
    log "Script executed without root permissions"
    echo "You must be root to run this program." >&2
    exit 3
fi

while getopts ":env:" opt; do
  case $opt in
    env)
      ENV=$OPTARG    
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done 


pip_install()
{
    wget https://raw.githubusercontent.com/riseinteractive/shared-scripts/master/spark16/requirements.txt
    /usr/bin/anaconda/bin/pip install -r requirements.txt
    rm requirements.txt
    /usr/bin/anaconda/bin/pip install oauth oauth2client==1.5.2
}

apt_install()
{
    apt-get update && apt-get dist-upgrade -y
    apt-get install htop vim-nox libjpeg-dev zlib1g-dev libffi-dev g++ librdkafka-dev build-essential libssl-dev python-dev
}

set_env()
{
    if grep -q "ENV=$ENV" "/etc/environment"; then
        echo "ENV already installed." 
    else
        echo "ENV=$ENV" >> /etc/environment
        echo "ENV installed."
    fi
}

set_env
pip_install
apt_install
exit 0