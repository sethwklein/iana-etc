# Copyright (c) 2003, 2004 Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 1.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-1.1.txt

# Makefile: See README for usage

PREFIX=
ETC_DIR=etc

.PHONY: all files get install clean dist \
    protocol-numbers.iana port-numbers.iana

all: files
files: protocols services

get: protocol-numbers.iana port-numbers.iana

install: files
	install -m 644 protocols ${PREFIX}/${ETC_DIR}
	install -m 644 services ${PREFIX}/${ETC_DIR}

clean:
	rm -vf \
	    protocols services \
	    protocol-numbers port-numbers \
	    protocol-numbers.iana port-numbers.iana

protocol-numbers.iana:
	gawk -f get.gawk -v file=protocol-numbers >protocol-numbers.iana
	rm -f protocol-numbers

port-numbers.iana:
	gawk -f get.gawk -v file=port-numbers >port-numbers.iana
	rm -f port-numbers

protocol-numbers:
ifeq (protocol-numbers.iana, $(wildcard protocol-numbers.iana))
	ln -s protocol-numbers.iana -f protocol-numbers
else
	ln -s protocol-numbers.dist -f protocol-numbers
endif

port-numbers:
ifeq (port-numbers.iana, $(wildcard port-numbers.iana))
	ln -s port-numbers.iana -f port-numbers
else
	ln -s port-numbers.dist -f port-numbers
endif

protocols: protocol-numbers
	gawk --re-interval -f protocols.gawk protocol-numbers > protocols

services: port-numbers
	gawk -f services.gawk port-numbers > services

dist: clean
	rm -vrf ../iana-etc-`cat VERSION`
	cp -a . ../iana-etc-`cat VERSION`
	tar --owner=root --group=root  -vjf ../iana-etc-`cat VERSION`.tar.bz2 \
	    -C .. -c iana-etc-`cat VERSION`

