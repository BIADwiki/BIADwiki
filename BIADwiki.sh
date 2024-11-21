#!/bin/sh
PATH="$PATH:/usr/local/bin/"

# git pull first
git status
git pull

# run R scripts
cd R
Rscript controller.R  > controller.Rout
scp controller.Rout root@biadwiki.org:2222/media/biad/controller.txt #this send file to a docker on biadwiki droplet
cd ..

# one last pull, then push the changes
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status

# update the Gists
cd ../Gists/table_comments

cd standard
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status
cd ..

cd zoptions
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status
cd ..


cd ..
cd summary_stats

cd row_counts
git status
git pull
git add -A
git commit -m "auto update from server"
git push
git status
cd ..
