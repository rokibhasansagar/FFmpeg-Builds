#!/bin/bash

SCRIPT_REPO="https://gitlab.freedesktop.org/fontconfig/fontconfig.git"
SCRIPT_COMMIT="04546f18768e1ce57c24743035118b3eabbd4181"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" fc
    cd fc

    ./autogen.sh --noconf

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --disable-docs
        --enable-libxml2
        --enable-iconv
        --disable-shared
        --enable-static
    )

    if [[ $TARGET == linux* ]]; then
        myconf+=(
            --sysconfdir=/etc
            --localstatedir=/var
            --host="$FFBUILD_TOOLCHAIN"
        )
    elif [[ $TARGET == win* ]]; then
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
    echo --enable-fontconfig
}

ffbuild_unconfigure() {
    echo --disable-fontconfig
}
