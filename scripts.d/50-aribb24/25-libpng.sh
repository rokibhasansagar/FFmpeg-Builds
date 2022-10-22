#!/bin/bash

SCRIPT_REPO="https://github.com/glennrp/libpng.git"
SCRIPT_COMMIT="e56f79c0c6d94f5d727fc147d4487038e188cdf2"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" libpng
    cd libpng

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --with-pic
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CPPFLAGS="$CPPFLAGS -I$FFBUILD_PREFIX/include"

    ./configure "${myconf[@]}"
    make -j4
    make install
}
