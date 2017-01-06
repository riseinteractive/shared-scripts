# Installation Instructions

This script is meant to be run on a 64-bit Ubuntu instance.  It will autodetect version changes, although the version of Shiny installed is presently static.  To run:

1.  Setup the public DNS in your `~/.ssh/config` with the correctly Rise `IdentityFile` set.  Otherwise, you'll have to manually pass in the key to Fabric.
2.  Install Fabric in your virtualenv: `pip install fabric`.
3.  Run the deployment script:

```bash
fab ubuntu:public-dns deploy
```
