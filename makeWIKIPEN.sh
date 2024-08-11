CURDIR=`pwd` || exit $?
NCPU=`grep -c processor /proc/cpuinfo` || exit $?
#install requirements
sudo apt install -y build-essential coreutils gzip bzip2 lbzip2 unzip mimetex libimage-magick-perl zlib1g-dev wget || exit $?
#retrieve wikipedia-fpw and extract
wget -nv -c http://green.ribbon.to/~ikazuhiro/dic/files/wikipedia-fpw-20091202-src.tar.gz || exit $?
tar -xzf wikipedia-fpw-20091202-src.tar.gz || exit $?
#install freepwing
wget -nv -c ftp://ftp.sra.co.jp/pub/misc/freepwing/freepwing-1.6.1.tar.bz2 || exit $?
tar -xjf freepwing-1.6.1.tar.bz2 || exit $?
cd freepwing-1.6.1 || exit $?
./configure --prefix=$CURDIR --with-perllibdir=$CURDIR/wikipedia-fpw-20091202 || exit $?
make -j$NCPU || exit $?
make install || exit $?
make clean || exit $?
cd .. || exit $?
rm -rf freepwing-1.6.1 || exit $?
#install eb
wget -nv -c https://github.com/mistydemeo/eb/releases/download/v4.4.3/eb-4.4.3.tar.bz2 || exit $?
tar -xjf eb-4.4.3.tar.bz2 || exit $?
cd eb-4.4.3 || exit $?
./configure --prefix=$CURDIR || exit $?
make -j$NCPU || exit $?
make install || exit $?
make clean || exit $?
cd .. || exit $?
rm -rf eb-4.4.3 || exit $?
#make EPWING data using wikipedia-fpw
cd wikipedia-fpw-20091202 || exit $?
#retrieve dump data of Wikipedia-EN
wget -nv -c https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2 || exit $?
#retrieve SHA1 checksum file
wget -nv -c https://dumps.wikimedia.org/enwiki/latest/enwiki-latest-sha1sums.txt || exit $?
#modify checksum file
perl -i -npe 's/(\senwiki)-(\d{8})-/$1-latest-/;if($.==1){print(STDERR "$2\n")}' enwiki-latest-sha1sums.txt 2> ../date.txt || exit $?
DATE=`cat ../date.txt` || exit $?
#test SHA1 checksum
sha1sum --ignore-missing -c enwiki-latest-sha1sums.txt || exit $?
#extract XML
lbzip2 -d enwiki-latest-pages-articles.xml.bz2 || exit $?
#change file name
mv enwiki-latest-pages-articles.xml wikipedia.xml || exit $?
#modify wikipedia-fpw.conf
perl -i -npe 's/mimetex\.exe/\/usr\/bin\/mimetex/;s/(math_black.*) 1/$1 0/;s/\^\(Wikipedia\|MediaWiki\|Template\|WP\|Portal\|Category\|Help\|Image\|画像\|ファイル\):/^(Wikipedia|MediaWiki|Template|WP|Portal|Category|Help|Image|File|Special|Module):/;s/(yomigana.*) 1/$1 0/' wikipedia-fpw.conf || exit $?
#modify catalogs.txt
perl -npe 's/(Title\s*=\s*).+/$1"Ｗｉｋｉｐｅｄｉａ（ｅｎ）"/;s/(Directory\s*=\s*)\S+/$1"WIKIPEN"/' catalogs.txt > catalogs.temp || exit $?
iconv -f utf8 -t euc-jp catalogs.temp > catalogs.txt || exit $?
#modify Makefile
perl -i -npe "s/^DIR = WIKIP/DIR = WIKIPEN/;s/^PACKAGE = wikipedia-fpw-20091202/PACKAGE = EPWING-Wikipedia-EN-$DATE/" Makefile || exit $?
#perform convert
PERL_USE_UNSAFE_INC=1 $CURDIR/bin/fpwmake catalogs || exit $?
PERL_USE_UNSAFE_INC=1 $CURDIR/bin/fpwmake -j$NCPU all
PERL_USE_UNSAFE_INC=1 $CURDIR/bin/fpwmake -j$NCPU INSTALLDIR=".." HASH_MOD=BDB FPWLINKMOD=BDB install
perl delduptag.pl work/texttag > work/texttag.new || exit $?
mv work/texttag work/texttag.old || exit $?
mv work/texttag.new work/texttag || exit $?
PERL_USE_UNSAFE_INC=1 $CURDIR/bin/fpwmake -j$NCPU INSTALLDIR=".." HASH_MOD=BDB FPWLINKMOD=BDB install || exit $?
PERL_USE_UNSAFE_INC=1 $CURDIR/bin/fpwmake clean || exit $?
cd .. || exit $?
rm -rf wikipedia-fpw-20091202 || exit $?
chmod 777 WIKIPEN || exit $?
#retrieve gaiji map
wget -nv -c -O gai16_xbm.zip https://ftp.iij.ad.jp/pub/osdn.jp/boookends/54674/gai16_xbm.zip || exit $?
unzip gai16_xbm.zip || exit $?
mv gai16_xbm/wikip.map WIKIPEN/WIKIPEN.map || exit $?
mv gai16_xbm/wikip.plist WIKIPEN/WIKIPEN.plist || exit $?
rm -rf gai16_xbm || exit $?
#compress ebook
cd WIKIPEN || exit $?
$CURDIR/bin/ebzip -z -f -l 5 || exit $?
cd .. || exit $?
