# Copyright (c) 2003, 2004 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 1.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-1.1.txt

BEGIN {
    print "# See also: protocols(5)" \
	", http://www.sethwklein.net/projects/iana-etc/\n#"
    header_printed = 0
    format = "%-12s %3s %-12s # %s\n"
}
{ sub(/\r/, "") }
match($0, /^[ \t]+([0-9]+)[ \t]{1,5}([^ \t]+)(.*)/, f) {
    if ( ! header_printed) {
	printf format, "# protocol", "num", "aliases", "comments"
	header_printed = 1;
    }
    sub(/^[ \t]*/, "", f[3])
    printf format, tolower(f[2]), f[1], f[2], f[3]
    next
}
{ print "# " $0 }
