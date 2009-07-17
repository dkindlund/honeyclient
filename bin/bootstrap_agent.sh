#!/bin/bash

# $Id$

echo "Starting up Agent - (Hit CTRL-C multiple times to exit.)"

# Remove all old /tmp/* entries.
rm /tmp/* > /dev/null 2>&1

# Remove any old capture logs entries.
rm -rf ~/honeyclient/thirdparty/capture-mod/logs

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

# Wait until the firewall has allowed network connectivity to this VM.
FIREWALL_STATUS=`(/cygdrive/c/windows/system32/ping.exe -n 1 -w 100 pingu.honeyclient.org > /dev/null 2>&1 && echo "ENABLED") || echo "DISABLED"`

while [ $FIREWALL_STATUS = "DISABLED" ] ; do
    echo "FIREWALL STATUS = $FIREWALL_STATUS"
    echo "Waiting for firewall to allow network connectivity to this VM."
    sleep 1 
    FIREWALL_STATUS=`(/cygdrive/c/windows/system32/ping.exe -n 1 -w 100 pingu.honeyclient.org > /dev/null 2>&1 && echo "ENABLED") || echo "DISABLED"`
done
echo "FIREWALL STATUS = $FIREWALL_STATUS"

# Change to the honeyclient directory.
cd ~/honeyclient 

# Perform an SVN update (optional).
svn update

# Suppress "Duplicate name exists on the network." error message.
perl bin/suppress_error.pl

# Start up the realtime integrity checker.
~/honeyclient/thirdparty/capture-mod/CaptureBAT.exe -c -l "C:\cygwin\tmp\realtime-changes.txt"&

# Start the Agent code.
perl -Ilib bin/StartAgent.pl
