#!/usr/bin/env bash

set -e

prefix=${WINEPREFIX:-$HOME/.wine}

# do bootstrap
if [[ ! -d $prefix/drive_c/mingw64 ]]; then
    echo "Installing MinGW"
    wget -q https://netix.dl.sourceforge.net/project/mingw-w64/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/8.1.0/threads-win32/seh/x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z -P /tmp
    7z x /tmp/x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z -o"$prefix/drive_c/" -y > /dev/null
    rm -f /tmp/x86_64-8.1.0-release-win32-seh-rt_v6-rev0.7z
    packages=(
        "mingw-w64-x86_64-SDL2-2.0.10-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-SDL2_image-2.0.5-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-SDL2_mixer-2.0.4-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-SDL2_net-2.0.1-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-SDL2_ttf-2.0.15-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-bzip2-1.0.8-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-flac-1.3.2-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-fluidsynth-2.0.5-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-freetype-2.10.1-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-gettext-0.19.8.1-8-any.pkg.tar.xz"
        "mingw-w64-x86_64-glib2-2.60.4-2-any.pkg.tar.xz"
        "mingw-w64-x86_64-graphite2-1.3.13-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-harfbuzz-2.5.3-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libffi-3.2.1-4-any.pkg.tar.xz"
        "mingw-w64-x86_64-libiconv-1.16-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libjpeg-turbo-2.0.2-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libmodplug-0.8.9.0-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libogg-1.3.3-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libpng-1.6.37-3-any.pkg.tar.xz"
        "mingw-w64-x86_64-libsndfile-1.0.28-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libtiff-4.0.10-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libvorbis-1.3.6-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-libwebp-1.0.3-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-mpg123-1.25.11-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-opus-1.3.1-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-opusfile-0.11-2-any.pkg.tar.xz"
        "mingw-w64-x86_64-pcre-8.43-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-pkg-config-0.29.2-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-portaudio-190600_20161030-3-any.pkg.tar.xz"
        "mingw-w64-x86_64-readline-8.0.000-4-any.pkg.tar.xz"
        "mingw-w64-x86_64-speex-1.2.0-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-termcap-1.3.1-5-any.pkg.tar.xz"
        "mingw-w64-x86_64-xz-5.2.4-1-any.pkg.tar.xz"
        "mingw-w64-x86_64-zlib-1.2.11-7-any.pkg.tar.xz"
        "mingw-w64-x86_64-zstd-1.4.2-1-any.pkg.tar.xz"
    )
    echo "Installing MinGW packages"
    for pkg in ${packages[*]}; do
        #echo $pkg
        wget -q "http://repo.msys2.org/mingw/x86_64/$pkg" -P /tmp
        tar -xf "/tmp/$pkg" -C "$prefix/drive_c"
        rm -f "/tmp/$pkg"
    done
    echo "Fixing PATH"
    echo "REGEDIT4

[HKEY_CURRENT_USER\Environment]
\"PATH\"=\"C:\\\\\\\\mingw64\\\\\\\\bin\"" > /tmp/path.reg
    wine regedit /tmp/path.reg
    rm -f /tmp/path.reg
fi
if [[ ! -d $prefix/drive_c/Program\ Files/Steel\ Bank\ Common\ Lisp ]]; then
    echo "Installing SBCL"
    wget -q https://netix.dl.sourceforge.net/project/sbcl/sbcl/1.4.14/sbcl-1.4.14-x86-64-windows-binary.msi -P /tmp
    wine msiexec /q /i /tmp/sbcl-1.4.14-x86-64-windows-binary.msi
    rm -f /tmp/sbcl-1.4.14-x86-64-windows-binary.msi
fi
if [[ ! -d $prefix/drive_c/users/$USER/quicklisp ]]; then
    echo "Installing QuickLisp"
    wget -q https://beta.quicklisp.org/quicklisp.lisp -P /tmp
    (cd /tmp && echo "(quicklisp-quickstart:install) (ql-util:without-prompting (ql:add-to-init-file))" | wine sbcl --load quicklisp.lisp)
    rm -f /tmp/quicklisp.lisp
    echo "Installing systems"
    echo "(ql:quickload :sdl2 :silent t) (ql:quickload :sdl2-image :silent t) (ql:quickload :sdl2-mixer :silent t) (ql:quickload :sdl2-ttf :silent t)" | wine sbcl
fi
echo "Bootstrap OK"

# do build
echo "Building"
builddir=$prefix/drive_c/users/$USER/build
rm -rf "$builddir"
mkdir -p "$builddir"
cp -r . "$builddir"
(cd "$builddir" && wine sbcl --script build.lisp)
echo "Packing"
mingwdir=$prefix/drive_c/mingw64/bin
zip -9 -j cl-sdl-test-windows.zip "$builddir/src/bin/test.exe" "$mingwdir/libbz2-1.dll" "$mingwdir/libffi-6.dll" "$mingwdir/libFLAC-8.dll" "$mingwdir/libfluidsynth-2.dll" "$mingwdir/libfreetype-6.dll" "$mingwdir/libgcc_s_seh-1.dll" "$mingwdir/libglib-2.0-0.dll" "$mingwdir/libgmodule-2.0-0.dll" "$mingwdir/libgraphite2.dll" "$mingwdir/libharfbuzz-0.dll" "$mingwdir/libiconv-2.dll" "$mingwdir/libintl-8.dll" "$mingwdir/libjpeg-8.dll" "$mingwdir/liblzma-5.dll" "$mingwdir/libmodplug-1.dll" "$mingwdir/libmpg123-0.dll" "$mingwdir/libogg-0.dll" "$mingwdir/libopus-0.dll" "$mingwdir/libopusfile-0.dll" "$mingwdir/libpcre-1.dll" "$mingwdir/libpng16-16.dll" "$mingwdir/libportaudio-2.dll" "$mingwdir/libreadline8.dll" "$mingwdir/libsndfile-1.dll" "$mingwdir/libspeex-1.dll" "$mingwdir/libstdc++-6.dll" "$mingwdir/libtermcap-0.dll" "$mingwdir/libtiff-5.dll" "$mingwdir/libvorbis-0.dll" "$mingwdir/libvorbisenc-2.dll" "$mingwdir/libvorbisfile-3.dll" "$mingwdir/libwebp-7.dll" "$mingwdir/libwinpthread-1.dll" "$mingwdir/libzstd.dll" "$mingwdir/SDL2.dll" "$mingwdir/SDL2_image.dll" "$mingwdir/SDL2_mixer.dll" "$mingwdir/SDL2_ttf.dll" "$mingwdir/zlib1.dll"
