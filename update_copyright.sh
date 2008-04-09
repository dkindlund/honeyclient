#!/usr/bin/bash

# $Id$

if [ -z $1 ] || [ -z $2 ] ; then
    echo "Copyright Updater"
    echo "Usage: $0 <old_year> <new_year>"
    echo ""
    echo "Example: $0 2007 2008"
    echo ""
    exit
fi

OLD_VERSION=$(echo $1 | sed -e 's/\./\\./g')
NEW_VERSION=$(echo $2 | sed -e 's/\./\\./g')

FILES=$(grep -r -P $OLD_VERSION lib/* | grep -v .svn | sed -e 's/:.*//g' | uniq)

echo "Updating copyrights in the following files:"
echo ""
for FILE in $FILES ; do
    TMPFILE=$(mktemp)
    echo "($1 -> $2) $FILE"
    cat $FILE | sed -e "s/Copyright (C) ${OLD_VERSION} The MITRE Corporation./Copyright (C) ${NEW_VERSION} The MITRE Corporation./g" > $TMPFILE
    mv $TMPFILE $FILE
done

echo ""
echo "Done.  Be sure to do an 'svn diff' before commiting,"
echo "in order to verify that no other data got altered."
