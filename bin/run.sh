#!/bin/bash

echo "Starting up Agent - (Hit CTRL-C multiple times to exit.)"

IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
echo "IP = $IP"

while [ $IP = "0.0.0.0" ] ; do
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -release
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -renew
    IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
    echo "IP = $IP"
    sleep 1 
done

ping www.honeyclient.org
cd ~/honeyclient && svn update

while [ true ] ; do
    sleep 5 && \
    perl -Ilib bin/StartAgent.pl
done
