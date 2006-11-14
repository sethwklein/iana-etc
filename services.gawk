#!/usr/bin/gawk -f

# Copyright (c) 2003-2004, 2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 3.0
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-3.0.txt

BEGIN {
    if (strip == "yes") {
	strip = 1
    } else {
	strip = 0
	print "# See also: services(5)" \
	    ", http://www.sethwklein.net/projects/iana-etc/\n#"
    }
    while (getline <"port-aliases") {
	sub(/#.*/, "")
	if (/^[ \t]*$/) { continue }
	alias_list[$1] = substr($0, index($0, $2))
    }
}
function aliases(n) {
    return ((n in alias_list) ? " " alias_list[n] : "")
}
{ sub(/\r/, "") }
match($0, /(^[[:alnum:]][^ \t]+)([ \t]+)([0-9]+(-[0-9]+)?)(\/[^ \t]+)?(.*)/, f) {
    name = f[1]
    whitespace = f[2]
    port = f[3]
    protocols[0] = f[5]
    comment = f[6]
    if (length(comment) > 0) {
	sub(/^[ \t]*/, "&# ", comment) }
    if (strip) {
	whitespace = "\t"
	comment = ""
    }
    start = end = port + 0
    if (match(port, /^([0-9]+)-([0-9]+)$/, n)) {
	start = n[1]
	end = n[2]
    }
    if (length(protocols[0]) == 0) {
	protocols[0] = "/tcp"
	protocols[1] = "/udp"
    }
    for (i = start; i <= end; i++) {
	for (p in protocols) {
	    print name whitespace i protocols[p] aliases(name) comment
	}
    }
    next
}
# add comment marker, prettily
!/^#/ && (sub(/^ /, "#") || sub(/^/, "# ")) {}
!strip { print }
