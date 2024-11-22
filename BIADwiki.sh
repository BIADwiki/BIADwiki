#!/bin/sh
PATH="$PATH:/usr/local/bin/"

# git pull first
git status
git pull

DATE=$(date +%Y%m%d)
#
# run R scripts
cd R
Rscript controller.R > controller.Rout_$DATE
## this should be changed and use a symlink to the last, but this will need adjustmenet depending on the docker
scp -F /dev/null -P 2222 controller.Rout_$DATE root@biadwiki.org:/media/biad/controller_last.txt
scp -F /dev/null -P 2222 controller.Rout_$DATE root@biadwiki.org:/media/biad/
scp -r -F /dev/null -P 2222 tools/templates/ root@biadwiki.org:/media/biad/
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
