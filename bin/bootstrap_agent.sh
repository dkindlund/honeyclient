#!/bin/bash

# $Id$

echo "Starting up Agent - (Hit CTRL-C multiple times to exit.)"

# Remove all old /tmp/* entries.
rm /tmp/* > /dev/null 2>&1

# Determine the IP address of the VM running.
IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
echo "IP = $IP"

# Wait until the VM has a valid IP address.
while [ $IP = "0.0.0.0" ] ; do
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -release
    /cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -renew
    IP=$(/cygdrive/c/Program\ Files/VMware/VMware\ Tools/VMip.exe -get)
    echo "IP = $IP"
    sleep 1 
done

# Ping a remote site, to test for connectivity.
/cygdrive/c/windows/system32/ping.exe pingu.honeyclient.org

# Change to the honeyclient directory.
cd ~/honeyclient 

# Perform an SVN update (optional).
svn update

# Start up the realtime integrity checker.
~/honeyclient/thirdparty/capture-mod/CaptureBAT.exe -c -l "C:\cygwin\tmp\realtime-changes.txt"&

# Start the Agent code.
while [ true ] ; do
    perl -Ilib bin/StartAgent.pl && sleep 1
done
