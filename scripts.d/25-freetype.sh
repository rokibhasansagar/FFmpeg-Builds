#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/freetype/freetype.git"
SCRIPT_COMMIT="ffbbf3df3eb72b75851fd370c96f637ce9476cac"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" freetype
    cd freetype

    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    ./configure "${myconf[@]}"
    make -j4
    make install
}

ffbuild_configure() {
    echo --enable-libfreetype
}

ffbuild_unconfigure() {
    echo --disable-libfreetype
}
