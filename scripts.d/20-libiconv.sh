#!/bin/bash

SCRIPT_REPO="https://git.savannah.gnu.org/git/libiconv.git"
SCRIPT_COMMIT="c593e206b2d4bc689950c742a0fb00b8013756a0"
SCRIPT_REPO2="https://repo.or.cz/libiconv.git"
SCRIPT_BRANCH2="master"

ffbuild_enabled() {
    return 0
}

ffbuild_dockerbuild() {
    git-mini-clone "$SCRIPT_REPO" "$SCRIPT_COMMIT" iconv || {
        rm -rf iconv 2>/dev/null
        git-mini-clone "$SCRIPT_REPO2" "${SCRIPT_BRANCH2}" iconv
    }
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
