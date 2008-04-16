#!/bin/bash

#DATASTORE_PATH="/vm/clones"
DATASTORE_PATH="/vm/suspicious"
LIST=$(find $DATASTORE_PATH -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

cd ..
for VM in $LIST ; do
    echo -n $VM
    perl -Ilib bin/identify_clients.pl $VM && echo " - Not In Database" || echo " - Exists In Database"
done
