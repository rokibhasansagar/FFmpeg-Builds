#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libiconv.git"
SCRIPT_COMMIT="c593e206b2d4bc689950c742a0fb00b8013756a0"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    retry-tool sh -c "rm -rf iconv && git clone '$SCRIPT_REPO' iconv"
    cd iconv
    git checkout "$SCRIPT_COMMIT"

    ./autopull.sh --one-time || {
        rm -rf gnulib 2>/dev/null
        git-mini-clone "https://repo.or.cz/gnulib.git" "master" "gnulib"
    }
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
