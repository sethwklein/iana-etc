#!/usr/bin/gawk -f

# Copyright (c) 2003-2004, 2006 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 2.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-2.1.txt

BEGIN {
    print "# See also: services(5)" \
	", http://www.sethwklein.net/projects/iana-etc/\n#"
    while (getline <"port-aliases") {
	sub(/#.*/, "")
	if (/^[ \t]*$/) { continue }
	aliases[$1] = substr($0, index($0, $2))
    }
}
{ sub(/\r/, "") }
match($0, /(^[^ \t]+)([ \t]+[0-9]+\/[^ \t]+)(.*)/, f) {
    sub(/^[ \t]+/, "&# ", f[3])
    print f[1] f[2] ((f[1] in aliases) ? " " aliases[f[1]] : "") f[3]
    next
}
# add comment marker, prettily
!/^#/ && (sub(/^ /, "#") || sub(/^/, "# ")) {}
{ print }
