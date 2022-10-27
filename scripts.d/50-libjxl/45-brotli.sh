#!/bin/bash

SCRIPT_REPO="https://github.com/google/brotli.git"
SCRIPT_COMMIT="6d03dfbedda1615c4cba1211f8d81735575209c8"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" brotli
    cd brotli

    mkdir build && cd build

    cmake -G Ninja -DCMAKE_TOOLCHAIN_FILE="$FFBUILD_CMAKE_TOOLCHAIN" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="$FFBUILD_PREFIX" -DCMAKE_POSITION_INDEPENDENT_CODE=ON ..
    ninja -j4
    ninja install
}
