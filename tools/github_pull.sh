#!/bin/bash

# pull from BIADwiki github repository
cd /home/admin/BIADwiki
git status
git pull

DATE=$(date +%Y%m%d)
export LOGDIR=$HOME/logs
