# dwm - dynamic window manager
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: options dwm

options:
	@echo dwm build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk inc/rwm.h

#config.h: config.def.h
#	cp config.def.h $@

lib/librwm.so: rwm/src/*.rs
	$(MAKE) -C rwm out/librwm.so
	mkdir -p lib/
	cp rwm/out/librwm.so lib/librwm.so

inc/rwm.h:
	$(MAKE) -C rwm out/rwm.h
	mkdir -p inc/
	cp rwm/out/rwm.h inc/rwm.h

dwm: ${OBJ} lib/librwm.so
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	-rm -f dwm ${OBJ} dwm-${VERSION}.tar.gz
	-rm -rf lib/ inc/
	$(MAKE) -C rwm clean

dist: clean
	mkdir -p dwm-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		dwm.1 drw.h util.h ${SRC} dwm.png transient.c dwm-${VERSION}
	tar -cf dwm-${VERSION}.tar dwm-${VERSION}
	gzip dwm-${VERSION}.tar
	rm -rf dwm-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f dwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/dwm
	install -Dm0755 lib/librwm.so ${DESTDIR}${PREFIX}/lib/librwm.so
	install -Dm0644 inc/rwm.h ${DESTDIR}${PREFIX}/usr/include/rwm.h
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < dwm.1 > ${DESTDIR}${MANPREFIX}/man1/dwm.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/dwm.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/dwm\
		${DESTDIR}${MANPREFIX}/man1/dwm.1
		${DESTDIR}${MANPREFIX}/lib/librwm.so
		${DESTDIR}${MANPREFIX}/usr/include/rwm.h

.PHONY: all options clean dist install uninstall
