#!/bin/bash

SCRIPT_REPO="https://github.com/drobilla/sord.git"
SCRIPT_COMMIT="4113c78db9969054354b153819bde4ff0c8b6a73"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" sord
    cd sord

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dtools=disabled
        -Dtests=disabled
    )

    CC="${FFBUILD_CROSS_PREFIX}gcc" CXX="${FFBUILD_CROSS_PREFIX}g++" ./waf configure "${mywaf[@]}"
    ./waf -j4
    ./waf install

    meson "${myconf[@]}" ..
    ninja -j4
    ninja install
}
