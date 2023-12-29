#!/bin/bash

SCRIPT_REPO="https://github.com/lu-zero/mfx_dispatch.git"
SCRIPT_COMMIT="f6aac4576826ed821c81231fdfb0d24047158e7d"

ffbuild_enabled() {
    [[ $TARGET == *arm64 ]] && return -1
    [[ $ADDINS_STR != *4.4* && $ADDINS_STR != *5.0* && $ADDINS_STR != *5.1* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
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

    ./configure "${myconf[@]}"
    make -j$(nproc)
    make install

    ln -s libmfx.pc "$FFBUILD_PREFIX"/lib/pkgconfig/mfx.pc
}

ffbuild_configure() {
    echo --enable-libmfx
}

ffbuild_unconfigure() {
    echo --disable-libmfx
}
