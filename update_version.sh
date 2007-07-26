#!/usr/bin/bash

if [ -z $1 ] || [ -z $2 ] ; then
    echo "Code Version Updater"
    echo "Usage: $0 <old_version> <new_version>"
    echo ""
    echo "Example: $0 0.95 0.96"
    echo ""
    exit
fi

OLD_VERSION=$(echo $1 | sed -e 's/\./\\./g')
NEW_VERSION=$(echo $2 | sed -e 's/\./\\./g')

FILES=$(grep -r -P $OLD_VERSION lib/* | grep -v .svn | sed -e 's/:.*//g' | uniq)

echo "Updating versions in the following files:"
echo ""
for FILE in $FILES ; do
    TMPFILE=$(mktemp)
    echo "($1 -> $2) $FILE"
    cat $FILE | sed -e "s/${OLD_VERSION}/${NEW_VERSION}/g" > $TMPFILE
    mv $TMPFILE $FILE
done

echo ""
echo "Done.  Be sure to do an 'svn diff' before commiting,"
echo "in order to verify that no other data got altered."
