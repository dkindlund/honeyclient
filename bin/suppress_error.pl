#!/usr/bin/perl -w

# Helper script, designed to suppress the "Duplicate name exists on the network." error message
# that pops up upon boot of the clone VM.

# $Id$

use strict;
use warnings;

use Win32::GuiTest qw(FindWindowLike GetWindowText SetForegroundWindow SendKeys);

my @windows = FindWindowLike(0, "System Error", "");
for (@windows) {
    SetForegroundWindow($_);
    SendKeys("{ENTER}");
}
