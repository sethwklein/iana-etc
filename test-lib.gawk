#!/usr/bin/gawk -f

# Copyright (c) 2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 2.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-2.1.txt

# This file is used by the *-test.gawk files

function normalize() {
    sub(/#.*/, "")
    sub(/[ \t]*$/, "")
    if (/^$/) {
	next }
    gsub(/[ \t]+/, " ")
}
function bad_line() {
    were_errors = 1
    print
}
END { if (were_errors) {
    print "Error: above lines are invalid"
    exit 1
} }

