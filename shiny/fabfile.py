from fabric.api import env, run, sudo
from fabric.operations import put
from fabric.contrib.files import append
from fabric.colors import green, red
from fabric.context_managers import hide
from fabric.utils import warn

"""
Usage:

fab ubuntu:ec2.aws.com deploy
"""


def deploy():
    setup_r()
    install_r()
    install_shiny()
    setup_odbc()
    setup_proxy()
    print(green("Deployed successfully"))


def check_system():
    pass


def setup_r():
    print(green("Setup R repository."))
    release = run("lsb_release -c | awk '{print $2}'")
    print("{release} detected".format(release=release))
    append(filename="/etc/apt/sources.list",
           text="deb http://cran.rstudio.com/bin/linux/ubuntu {release}/".format(release=release),
           use_sudo=True)

    with hide('stdout'):
        sudo("apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9")
        sudo("apt-get update")


def install_r():
    print(green("Installing base R packages."))
    with hide('stdout'):
        # build-dep first to ensure no errors when running update.packages() on the system
        sudo('apt-get build-dep -y r-base r-recommended r-base-dev r-cran-rodbc r-cran-reshape2 r-cran-mvtnorm r-cran-dbi')
        sudo('apt-get install -y r-base r-recommended r-base-dev r-cran-rodbc r-cran-reshape2 r-cran-mvtnorm r-cran-dbi')


def install_shiny():
    print(green("Installing Shiny in R"))
    with hide('stdout'):
        sudo("apt-get install -y build-essential gdebi-core")
        sudo("R -e \"update.packages(ask=FALSE, repos='https://cran.rstudio.com/')\"")
        sudo("R -e \"install.packages('shiny', repos='https://cran.rstudio.com/')\"")

    print(green("Installing Shiny-Server"))
    run("wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.1.834-amd64.deb")
    sudo("gdebi -n shiny-server-1.5.1.834-amd64.deb")

    # Ensure that system.d service initiated correctly
    shiny_listen = sudo("netstat -ntlp | grep :3838 | awk '{print $6}'")
    if shiny_listen == "LISTEN":
        print(green("Shiny is running"))
    else:
        warn("Shiny service is not running")


def setup_odbc():
    print(green("Setting up ODBC."))
    sudo("apt-get install -y unixodbc unixodbc-dev freetds-dev tdsodbc")
    append(filename="/etc/freetds.conf",
           text="[rexmetrics]\n\thost = 10.201.0.40\n\tport = 1433\n\ttds version = 8.0",
           use_sudo=True)
    append(filename="/etc/odbc.ini",
           text="[rexmetrics]\nDriver = /usr/local/lib/libtdsodbc.so\nSetup = /usr/local/lib/libtdsodbc.so\nServerName = rexmetrics\nPort = 1433\nDatabase = RexMetrics",
           use_sudo=True)


def setup_proxy():
    print(green("Installing nginx as reverse proxy"))
    with hide('stdout'):
        sudo("apt-get install -y nginx-full nginx-full-dbg")

    put("default", "/etc/nginx/sites-enabled/", use_sudo=True)
    sudo("mkdir -p /etc/nginx/conf")
    put("htpasswd", "/etc/nginx/conf/", use_sudo=True)
    sudo("service nginx restart")


def ubuntu(host):
    env.user = "ubuntu"
    env.hosts = host
    env.use_ssh_config = True
