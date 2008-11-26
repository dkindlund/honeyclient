#!/bin/sh

# Helper script, designed to reset the firewall before starting
# the Manager.

# $Id$

/usr/bin/sudo /etc/init.d/ufw restart
