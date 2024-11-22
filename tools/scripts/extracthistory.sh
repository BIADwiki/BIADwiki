#!/usr/bin/env bash
DONE=false
FILE="$1"
EXPORTFILE=routpast/exportfile
git log --all --full-history --pretty=format:"%h" -- "${FILE}" |until $DONE
do read || DONE=true
  echo "Exporting $FILE as of commit $REPLY to $EXPORTFILE-$REPLY"
  git show $REPLY:"$FILE" > $EXPORTFILE-$REPLY
done


