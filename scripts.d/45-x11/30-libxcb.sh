#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/xorg/lib/libxcb.git"
SCRIPT_COMMIT="9dcb08170898d3bd5ddb3bc26c514a6bfccf3fae"

ffbuild_enabled() {
    [[ $TARGET != linux* ]] && return -1
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" libxcb
    cd libxcb

    autoreconf -i

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-shared
        --disable-static
        --with-pic
        --disable-devel-docs
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --host="$FFBUILD_TOOLCHAIN"
        )
    else
        echo "Unknown target"
        return -1
    fi

    export CFLAGS="$RAW_CFLAGS"
    export LDFLAFS="$RAW_LDFLAGS"

    ./configure "${myconf[@]}"
    make -j4
    make install

    for LIBNAME in "$FFBUILD_PREFIX"/lib/libxcb*.so.?; do
        gen-implib "$LIBNAME" "${LIBNAME%%.*}.a"
        rm "${LIBNAME%%.*}"{.so*,.la}
    done
}

ffbuild_configure() {
    echo --enable-libxcb
}

ffbuild_unconfigure() {
    echo --disable-libxcb
}
