# EPWING-Wikipedia-EN

The JIS X 4081 (EPWING-compatible) format electronic dictionary generated from dump data of en.wikipedia.org and converter script.
This script is based on the following products.

- [FreePWING](ftp://ftp.sra.co.jp/pub/misc/freepwing/)
- [EB Library](https://github.com/mistydemeo/eb)
- [wikipedia-fpw](http://green.ribbon.to/~ikazuhiro/dic/wikipedia-fpw.html)
- [Dump data of en.wikipedia.org](https://dumps.wikimedia.org/enwiki/)

## How to use

1. Download latest [release files of this package](https://github.com/astanabe/EPWING-Wikipedia-EN/releases)
2. Run file integrity check script `checkWIKIPEN-XXXXXXXX.sh`
3. Run file concatenation script `catWIKIPEN-XXXXXXXX.sh`
4. Run file extraction script `extractWIKIPEN-XXXXXXXX.sh`
5. Then, you will get JIS X 4081 (EPWING-compatible) format electronic dictionary as `WIKIPEN` directory
