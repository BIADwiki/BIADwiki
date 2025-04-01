#!/bin/bash

# pull from BIADwiki github repository
cd /home/admin/BIADwkik
git status
git pull

DATE=$(date +%Y%m%d)
export LOGDIR=$HOME/logs
