#!/bin/bash

SDL_SRC="https://libsdl.org/release/SDL2-2.0.16.tar.gz"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    mkdir sdl
    cd sdl

    wget -O SDL.tar.gz "$SDL_SRC" --tries=3 || curl -L -o SDL.tar.gz "$SDL_SRC" --retry 3
    tar xaf SDL.tar.gz
    rm SDL.tar.gz
    cd SDL*

    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-shared
        --enable-static
        --enable-x11-shared
        --enable-video-x11
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
}

ffbuild_configure() {
    echo --enable-sdl2
}

ffbuild_unconfigure() {
    echo --disable-sdl2
}

ffbuild_cflags() {
    return 0
}

ffbuild_ldflags() {
    return 0
}
