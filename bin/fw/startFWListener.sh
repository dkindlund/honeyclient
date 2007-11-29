#!/bin/sh

#cd /usr/src/honeyclient-trunk
#svn update

cd /hc
/usr/bin/perl /hc/startFWListener.pl > /dev/null 2> /dev/null &
