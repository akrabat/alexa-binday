#!/bin/bash

# Run wsk action update for a set of zip files

GIT_HASH=`git rev-parse HEAD`

PACKAGE=$1
shift

if [ -z $PACKAGE ] ; then
    echo "Usage: update.sh {package name} {zip file 1} [{zip file 2}] [{zip file 2}] ..."
fi


for arg
do
    ZIP_FILE=$arg

    ACTION_NAME=${arg%.zip}  # retain the part before the .
    ACTION_NAME=${ACTION_NAME##*/}  # retain the part after the last slash
    
    wsk action update $PACKAGE/$ACTION_NAME $ZIP_FILE --kind swift:3.1.1 \
      --web true \
      --annotation git_hash "$GIT_HASH"
done
