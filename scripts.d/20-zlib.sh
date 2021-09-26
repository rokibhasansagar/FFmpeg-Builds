#!/bin/bash

ZLIB_SRC="https://zlib.net/zlib-1.2.11.tar.gz"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    mkdir zlib
    cd zlib

    wget -O zlib.tar.gz "$ZLIB_SRC" --tries=3 || curl -L -o zlib.tar.gz "$ZLIB_SRC" --retry 3
    tar xaf zlib.tar.gz
    rm zlib.tar.gz
    cd zlib*

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        export CC="${FFBUILD_CROSS_PREFIX}gcc"
        export AR="${FFBUILD_CROSS_PREFIX}ar"
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install
}

ffbuild_configure() {
    echo --enable-zlib
}

ffbuild_unconfigure() {
    echo --disable-zlib
}
