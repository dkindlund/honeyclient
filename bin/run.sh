#!/bin/bash

# $Id$

echo "Starting up Agent - (Hit CTRL-C multiple times to exit.)"

# Remove all old /tmp/* entries.
rm /tmp/* > /dev/null 2>&1

IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
echo "IP = $IP"

while [ $IP = "0.0.0.0" ] ; do
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -release
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -renew
    IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
    echo "IP = $IP"
    sleep 1 
done

ping pingu.honeyclient.org
cd ~/honeyclient && svn update

~/honeyclient/Capture2/capture-client-xeno-mod/install/CaptureBAT.exe -c -l "C:\cygwin\tmp\realtime-changes.txt"&

while [ true ] ; do
    perl -Ilib bin/StartAgent.pl && sleep 1
done
