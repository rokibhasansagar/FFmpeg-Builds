#!/bin/bash

SCRIPT_REPO="https://github.com/drobilla/zix.git"
SCRIPT_COMMIT="c271dbeb9787b8a223c3049342468e720cc760b3"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    mkdir build && cd build

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --buildtype=release
        --default-library=static
        -Ddocs=disabled
        -Dbenchmarks=disabled
        -Dtests=disabled
        -Dtests_cpp=disabled
    )

    if [[ $TARGET == win* || $TARGET == linux* ]]; then
        myconf+=(
            --cross-file=/cross.meson
        )
    else
        echo "Unknown target"
        return -1
    fi

    meson "${myconf[@]}" ..
    ninja -j$(nproc)
    ninja install
}
