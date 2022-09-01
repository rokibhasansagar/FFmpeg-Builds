#!/bin/bash

SCRIPT_REPO="https://github.com/lv2/sratom.git"
SCRIPT_COMMIT="145ed2fe9756f707d9fd5f03ada5327d04e1b972"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" sratom
    cd sratom

    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dtests=disabled
    )

    CC="${FFBUILD_CROSS_PREFIX}gcc" CXX="${FFBUILD_CROSS_PREFIX}g++" ./waf configure "${mywaf[@]}"
    ./waf -j4
    ./waf install

    meson "${myconf[@]}" ..
    ninja -j"$(nproc)"
    ninja install
}
