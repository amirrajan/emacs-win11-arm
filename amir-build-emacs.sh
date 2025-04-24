cd /c/other-projects/emacs
sh ./autogen.sh

# from blog post
./configure --prefix=/c/emacs --without-pop --without-imagemagick --without-compress-install -without-dbus --with-gnutls --with-json --with-tree-sitter \
            --without-gconf --with-rsvg --without-gsettings --with-mailutils \
            --with-native-compilation --with-modules  --with-xml2 --with-wide-int \
            CFLAGS="-O3 -fno-math-errno -funsafe-math-optimizations -fno-finite-math-only -fno-trapping-math \
                  -freciprocal-math -fno-rounding-math -fno-signaling-nans \
                  -fassociative-math -fno-signed-zeros -frename-registers -funroll-loops \
                  -mtune=native -march=native -fomit-frame-pointer \
                  -fallow-store-data-races  -fno-semantic-interposition -floop-parallelize-all -ftree-parallelize-loops=4 -Wno-implicit-function-declaration -Wno-unused-function"

make
mkdir /c/emacs
make install DESTDIR=/c/emacs
