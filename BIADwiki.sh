#!/bin/sh
PATH="$PATH:/usr/local/bin/"

# git pull first
git status
git pull

# run R scripts
cd R
R CMD BATCH --no-save controller.R
cd ..

# one last pull, then push the changes
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status

# update the Gists
ls
cd ..
ls
cd Gists/Phases
ls
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status