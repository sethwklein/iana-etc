# Copyright (c) 2003, 2004 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 1.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-1.1.txt

# get.awk: retrieves IANA numbers assignments from iana.org.
# Requires GNU Awk.
# Usage: get.gawk -v file=<filename>

BEGIN {
    host = "www.iana.org"
    path = "/assignments/"
    # file is set by the caller
    socket = "/inet/tcp/0/" host "/80"

    print "Getting http://" host path file >"/dev/stderr"
    RS="\r\n"
    print "GET " path file " HTTP/1.0\r\nHost: " host "\r\n" |& socket
    printf "Request sent, waiting for data... " >"/dev/stderr"

    NR = 0
    while (socket |& getline) {
	if (!NR) { printf "receiving data... " >"/dev/stderr" }
	if (!(NR % 128)) { printf "." >"/dev/stderr" }
	NR++

	if (in_content) { print }
	if (/^$/)       { in_content=1 }
    }

    printf "\n" >"/dev/stderr"
    exit
}

