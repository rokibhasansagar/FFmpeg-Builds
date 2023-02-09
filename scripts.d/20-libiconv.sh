#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libiconv.git"
SCRIPT_COMMIT="0a05ca75c08ae899f6fca5f79254491e13ffb500"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    retry-tool sh -c "rm -rf iconv && git clone '$SCRIPT_REPO' iconv"
    cd iconv
    git checkout "$SCRIPT_COMMIT"

    ./autopull.sh --one-time || git-mini-clone "https://git.savannah.gnu.org/git/gnulib.git" "master" "gnulib"
    ./autogen.sh

    local myconf=(
        --prefix="$FFBUILD_PREFIX"
        --enable-extra-encodings
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
    make -j4
    make install
}

ffbuild_configure() {
    echo --enable-iconv
}

ffbuild_unconfigure() {
    echo --disable-iconv
}
