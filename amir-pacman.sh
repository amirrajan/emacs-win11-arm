pacman -Sy --noconfirm --needed filesystem msys2-runtime bash libreadline libiconv libarchive libgpgme libcurl pacman ncurses libintl
pacman -Su
pacman -S autoconf autogen automake automake-wrapper diffutils git guile libgc libguile libltdl libunistring  make mingw-w64-x86_64-binutils --noconfirm
pacman -S mingw-w64-x86_64-bzip2 mingw-w64-x86_64-cairo mingw-w64-x86_64-crt-git mingw-w64-x86_64-dbus mingw-w64-x86_64-expat --noconfirm
pacman -S mingw-w64-x86_64-glib2 mingw-w64-x86_64-gmp mingw-w64-x86_64-gnutls mingw-w64-x86_64-harfbuzz mingw-w64-x86_64-headers-git mingw-w64-x86_64-imagemagick mingw-w64-x86_64-isl  mingw-w64-x86_64-libffi mingw-w64-x86_64-libgccjit --noconfirm
pacman -S mingw-w64-x86_64-libiconv  mingw-w64-x86_64-libjpeg-turbo mingw-w64-x86_64-libpng mingw-w64-x86_64-librsvg mingw-w64-x86_64-libtiff mingw-w64-x86_64-libwinpthread-git mingw-w64-x86_64-libxml2 --noconfirm
pacman -S mingw-w64-x86_64-mpc mingw-w64-x86_64-mpfr mingw-w64-x86_64-pango mingw-w64-x86_64-pixman mingw-w64-x86_64-winpthreads mingw-w64-x86_64-xpm-nox mingw-w64-x86_64-lcms2 mingw-w64-x86_64-xz mingw-w64-x86_64-zlib tar wget --noconfirm
pacman -S texinfo --noconfirm
pacman -S pkg-config --noconfirm
pacman -S mingw-w64-x86_64-jansson --noconfirm
pacman -S mingw-w64-x86_64-tree-sitter --noconfirm
