# FFmpeg Static Auto-Builds

Windows (x86_64 & x86) and Linux (x86_64 & arm64) Builds of (Static & Shared) ffmpeg master and two latest stable release branches.

Windows builds are targetting Windows 7 and newer.

Linux (x86_64) builds are targetting Ubuntu 16.04 (glibc-2.23 + linux-4.4) and anything more recent.

Linux (arm64) builds are targetting Ubuntu 18.04 (glibc-2.27 + linux-4.15) and anything more recent.

## Auto-Builds

Builds run at 01:00 UTC on roughly every 4th day of every month (or GitHub's idea of that time) and are automatically released on success.

**Auto-Builds run for gpl, lgpl and nonfree variants for all 64-bit platforms. There are no win32/x86 auto-builds, though you can produce win32 builds yourself following the instructions below.**

### Release Retention Policy

- The last build of each month is kept for two years.
- The last 7 daily(!) builds are kept.
- The special "latest" build floats and provides consistent URLs always pointing to the latest build.

## Package List

For a list of included dependencies check the `scripts.d` directory.
Every file corresponds to its respective package.

## How to make a build

### Prerequisites

* bash
* docker

### Build Image

* `./makeimage.sh target variant [addin [addin] [addin] ...]`

### Build FFmpeg

* `./build.sh target variant [addin [addin] [addin] ...]`

On success, the resulting zip/tar.xz archive file will be in the `artifacts` subdir.

### Targets, Variants and Addins

Available targets:
* `win64` (x86_64 Windows)
* `win32` (x86 Windows)
* `linux64` (x86_64 Linux, glibc>=2.23, linux>=4.4)
* `linuxarm64` (arm64 (aarch64) Linux, glibc>=2.27, linux>=4.15)

The linuxarm64 target will not build some dependencies due to lack of arm64 (aarch64) architecture support or cross-compiling restrictions.

* `davs2` and `xavs2`: aarch64 support is broken.
* `libmfx` and `libva`: Library for Intel QSV, so there is no aarch64 support.

Available variants:
* `gpl` Includes all dependencies, even those that require full GPL instead of just LGPL.
* `lgpl` Lacking libraries that are GPL-only. Most prominently libx264 and libx265.
* `nonfree` Includes fdk-aac in addition to all the dependencies of the gpl variant.
* `gpl-shared` Same as gpl, but comes with the libav* family of shared libs instead of pure static executables.
* `lgpl-shared` Same again, but with the lgpl set of dependencies.
* `nonfree-shared` Same again, but with the nonfree set of dependencies.

All of those can be optionally combined with any combination of addins:
* `4.4`/`5.0`/`5.1`/`6.0` to build from the respective release branch instead of master.
* `debug` to not strip debug symbols from the binaries. This increases the output size by about 250MB.
* `lto` build all dependencies and ffmpeg with -flto=auto (HIGHLY EXPERIMENTAL, broken for Windows, sometimes works for Linux)
