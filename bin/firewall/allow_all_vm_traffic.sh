#!/bin/sh

# Helper script, designed to allow all network traffic to/from any VM
# on the 'Honeyclient Network'.

# $Id$

/sbin/iptables -t filter -F
/sbin/iptables -t filter -X
/sbin/iptables -t filter -P INPUT ACCEPT
/sbin/iptables -t filter -P OUTPUT ACCEPT
/sbin/iptables -t filter -P FORWARD ACCEPT
