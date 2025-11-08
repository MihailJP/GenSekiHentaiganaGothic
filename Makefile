FONTS=GenSekiHentaiganaGothic.ttf \
      GenSekiHentaiganaGothic-Bold.ttf
CSS=GenSekiHentaiganaGothic.css
OTFONTS=${FONTS:.ttf=.otf}
WOFFFONTS=${FONTS:.ttf=.woff}
WOFF2FONTS=${FONTS:.ttf=.woff2}
UFOS=${FONTS:.ttf=.ufo}
DOCUMENTS=README.md ChangeLog LICENSE
PKGS=GenSekiHentaiganaGothic.tar.xz GenSekiHentaiganaGothic-OT.tar.xz GenSekiHentaiganaGothic-WOFF2.tar.xz
TTFPKGCMD=rm -rf $*; mkdir $*; rsync -R ${FONTS} ${DOCUMENTS} $*
OTFPKGCMD=rm -rf $*; mkdir $*; rsync -R ${OTFONTS} ${DOCUMENTS} $*
WOFF2PKGCMD=rm -rf $*; mkdir $*; rsync -R ${WOFF2FONTS} ${CSS} ${DOCUMENTS} $*

.PHONY: all
all: ttf otf woff2

.SUFFIXES: .sfd .ttf .otf .woff .woff2 .ufo

.sfd.ttf .sfd.otf .sfd.woff .sfd.woff2:
	for i in $?;do fontforge -lang=py -c "font=fontforge.open('$$i'); font.buildOrReplaceAALTFeatures(); fontforge.setPrefs('CoverageFormatsAllowed', 1); font.generate('$@', flags=('opentype', 'no-mac-names')); font.close()";done
.sfd.ufo:
	for i in $?;do fontforge -lang=py -c "font=fontforge.open('$$i'); font.generate('$@', flags=('opentype', 'no-mac-names')); font.close()";done
	grep "^Version: " GenSekiHentaiganaGothic.sfd | sed -e "s/^Version: //"
	sed -i~ -e "/<key>openTypeNameVersion<\/key>/ { n; s/<string>.*<\/string>/<string>$$(grep "^Version: " $< | sed -e "s/^Version: //")<\/string><key>postscriptIsFixedPitch<\/key><true\/>/; }" $@/fontinfo.plist

.PHONY: ttf otf woff woff2
ttf: ${FONTS}
otf: ${OTFONTS}
woff: ${WOFFFONTS}
woff2: ${WOFF2FONTS}

.SUFFIXES: .tar.xz .tar.gz .tar.bz2 .zip
.PHONY: dist
dist: ${PKGS}

GenSekiHentaiganaGothic.tar.xz: ${FONTS} ${DOCUMENTS}
	${TTFPKGCMD}; tar cfvJ $@ $*
GenSekiHentaiganaGothic.tar.gz: ${FONTS} ${DOCUMENTS}
	${TTFPKGCMD}; tar cfvz $@ $*
GenSekiHentaiganaGothic.tar.bz2: ${FONTS} ${DOCUMENTS}
	${TTFPKGCMD}; tar cfvj $@ $*
GenSekiHentaiganaGothic.zip: ${FONTS} ${DOCUMENTS}
	${TTFPKGCMD}; zip -9r $@ $*

GenSekiHentaiganaGothic-OT.tar.xz: ${OTFONTS} ${DOCUMENTS}
	${OTFPKGCMD}; tar cfvJ $@ $*
GenSekiHentaiganaGothic-OT.tar.gz: ${OTFONTS} ${DOCUMENTS}
	${OTFPKGCMD}; tar cfvz $@ $*
GenSekiHentaiganaGothic-OT.tar.bz2: ${OTFONTS} ${DOCUMENTS}
	${OTFPKGCMD}; tar cfvj $@ $*
GenSekiHentaiganaGothic-OT.zip: ${OTFONTS} ${DOCUMENTS}
	${OTFPKGCMD}; zip -9r $@ $*

GenSekiHentaiganaGothic-WOFF2.tar.xz: ${WOFF2FONTS} ${CSS} ${DOCUMENTS}
	${WOFF2PKGCMD}; tar cfvJ $@ $*
GenSekiHentaiganaGothic-WOFF2.tar.gz: ${WOFF2FONTS} ${CSS} ${DOCUMENTS}
	${WOFF2PKGCMD}; tar cfvz $@ $*
GenSekiHentaiganaGothic-WOFF2.tar.bz2: ${WOFF2FONTS} ${CSS} ${DOCUMENTS}
	${WOFF2PKGCMD}; tar cfvj $@ $*
GenSekiHentaiganaGothic-WOFF2.zip: ${WOFF2FONTS} ${CSS} ${DOCUMENTS}
	${WOFF2PKGCMD}; zip -9r $@ $*

ChangeLog: .git # GIT
	./mkchglog.rb > $@ # GIT

.PHONY: clean
clean:
	-rm -f ${FONTS} ${OTFONTS} ${WOFFFONTS} ${WOFF2FONTS} ChangeLog
	-rm -rf ${PKGS} ${PKGS:.tar.xz=} ${PKGS:.tar.xz=.tar.bz2} \
	${PKGS:.tar.xz=.tar.gz} ${PKGS:.tar.xz=.zip}
