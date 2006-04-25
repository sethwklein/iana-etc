#!/usr/bin/gawk --re-interval -f test-lib.gawk -f
# the above doesn't work (stupid kernel) but serves as documentation

# Copyright (c) 2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 2.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-2.1.txt

length > 1024-1 { bad_line() }
{
    normalize()
    if (/^[a-zA-Z0-9_+*/.-]+ [0-9]+\/[a-z]+( [a-zA-Z0-9_+*/.-]+){0,35}$/) {
	next }
    bad_line()
}
