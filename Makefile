# Copyright (c) 2003-2006, Seth W. Klein <sk@sethwklein.net>
# Licensed under the Open Software License version 2.1
# See the file COPYING in the distribution tarball or
# http://www.opensource.org/licenses/osl-2.1.txt

# Makefile: See README for usage

DESTDIR=
PREFIX=
ETC_DIR=/etc

AWK=gawk

.PHONY: all files get install clean dist \
    protocol-numbers.iana port-numbers.iana

all: files
files: protocols services

get: protocol-numbers.iana port-numbers.iana

test: test-protocols test-services

test-services: services
	$(AWK) --re-interval -f test-lib.gawk -f services-test.gawk <services

test-protocols: protocols
	$(AWK) -f test-lib.gawk -f protocols-test.gawk <protocols

install: files
	install -d $(DESTDIR)$(PREFIX)$(ETC_DIR)
	install -m 644 protocols $(DESTDIR)$(PREFIX)$(ETC_DIR)
	install -m 644 services $(DESTDIR)$(PREFIX)$(ETC_DIR)

clean:
	rm -vf \
	    protocols services \
	    protocol-numbers port-numbers \
	    protocol-numbers.iana port-numbers.iana

protocol-numbers.iana:
	$(AWK) -f get.gawk -v file=protocol-numbers >protocol-numbers.iana
	rm -f protocol-numbers

port-numbers.iana:
	$(AWK) -f get.gawk -v file=port-numbers >port-numbers.iana
	rm -f port-numbers

protocol-numbers:
ifeq (protocol-numbers.iana, $(wildcard protocol-numbers.iana))
	ln -f -s protocol-numbers.iana protocol-numbers
else
	ln -f -s protocol-numbers.dist protocol-numbers
endif

port-numbers:
ifeq (port-numbers.iana, $(wildcard port-numbers.iana))
	ln -f -s port-numbers.iana port-numbers
else
	ln -f -s port-numbers.dist port-numbers
endif

protocols: protocol-numbers
	$(AWK) --re-interval -f protocols.gawk protocol-numbers > protocols

services: port-numbers
	$(AWK) -f services.gawk port-numbers > services

dist: clean
	rm -vrf ../iana-etc-`cat VERSION`
	cp -a . ../iana-etc-`cat VERSION`
	tar --owner=root --group=root  -vjf ../iana-etc-`cat VERSION`.tar.bz2 \
	    -C .. -c iana-etc-`cat VERSION`

