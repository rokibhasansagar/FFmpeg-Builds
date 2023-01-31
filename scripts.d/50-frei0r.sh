#!/bin/bash

SCRIPT_REPO="https://github.com/dyne/frei0r.git"
SCRIPT_COMMIT="a9d15ff07e130baf3408da6e1f1b22f82e7c62b6"

ffbuild_enabled() {
    [[ $VARIANT == lgpl* ]] && return -1
    [[ $ADDINS_STR == *4.4* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" frei0r
    cd frei0r

    mkdir build && cd build

    cmake -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" ..

    mkdir -p "$FFBUILD_PREFIX"/lib/pkgconfig
    cp frei0r.pc "$FFBUILD_PREFIX"/lib/pkgconfig

    ./configure "${myconf[@]}"
    make -C include -j4
    make -C include install
    make install-pkgconfigDATA
}

ffbuild_configure() {
    echo --enable-frei0r
}

ffbuild_unconfigure() {
    echo --disable-frei0r
}
