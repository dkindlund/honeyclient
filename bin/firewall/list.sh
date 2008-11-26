#!/bin/sh

# Helper script, designed to list all firewall rules
# that are currently active.

# $Id$

/sbin/iptables-save
