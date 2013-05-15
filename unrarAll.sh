for fileDotRar in `find . -maxdepth 1 -size +1c -name "*.rar"`; do unar -D $fileDotRar; done
