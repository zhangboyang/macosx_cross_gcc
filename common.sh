#!/bin/bash

# directory
PREFIX=`pwd`
SRC="${PREFIX}/src"

UTIL_SRC="${SRC}/util"

TOOLCHAIN_SRC="${SRC}/toolchain"
NATIVE_SRC="${TOOLCHAIN_SRC}/native"
CROSS_SRC="${TOOLCHAIN_SRC}/cross"
QEMU_SRC="${SRC}/qemu"
TINYLINUX_SRC="${SRC}/tinylinux"

SYSROOT="${PREFIX}/sysroot"

GCC_NATIVE_PREFIX="${PREFIX}/gcc-native"
GCC_CROSS_PREFIX="${PREFIX}/gcc-cross"
UTIL_PREFIX="${PREFIX}/utils"
LIB_PREFIX="${PREFIX}/libs"
SCRIPT_PREFIX="${PREFIX}/scripts"

# source - wget
WGET_VER=wget-1.17.1
WGET_TARBALL="${WGET_VER}.tar.gz"
WGET_URL="http://mirrors.ustc.edu.cn/gnu/wget/${WGET_TARBALL}"
# source - util
SED_VER=sed-4.2
AWK_VER=gawk-4.1.3
XZ_VER=xz-5.2.2
FINDUTILS_VER=findutils-4.6.0
SED_TARBALL="${SED_VER}.tar.gz"
AWK_TARBALL="${AWK_VER}.tar.gz"
XZ_TARBALL="${XZ_VER}.tar.gz"
FINDUTILS_TARBALL="${FINDUTILS_VER}.tar.gz"
SED_URL="http://mirrors.ustc.edu.cn/gnu/sed/${SED_TARBALL}"
AWK_URL="http://mirrors.ustc.edu.cn/gnu/gawk/${AWK_TARBALL}"
XZ_URL="http://tukaani.org/xz/${XZ_TARBALL}"
FINDUTILS_URL="http://mirrors.ustc.edu.cn/gnu/findutils/${FINDUTILS_TARBALL}"
# source - toolchain
BINUTILS_VER=binutils-2.25
GLIBC_VER=glibc-2.22
GCC_VER=gcc-5.3.0
GMP_VER=gmp-4.3.2
MPC_VER=mpc-0.8.1
MPFR_VER=mpfr-2.4.2
ISL_VER=isl-0.14
LINUX_VER=linux-4.4
LINUX_MAJOR_VER=v4.x
GETTEXT_VER=gettext-0.19.7
BINUTILS_TARBALL="${BINUTILS_VER}.tar.bz2"
GLIBC_TARBALL="${GLIBC_VER}.tar.bz2"
GCC_TARBALL="${GCC_VER}.tar.bz2"
GMP_TARBALL="${GMP_VER}.tar.bz2"
MPC_TARBALL="${MPC_VER}.tar.gz"
MPFR_TARBALL="${MPFR_VER}.tar.gz"
ISL_TARBALL="${ISL_VER}.tar.bz2"
LINUX_TARBALL="${LINUX_VER}.tar.gz"
GETTEXT_TARBALL="${GETTEXT_VER}.tar.gz"
BINUTILS_URL="http://mirrors.ustc.edu.cn/gnu/binutils/${BINUTILS_TARBALL}"
GLIBC_URL="http://mirrors.ustc.edu.cn/gnu/glibc/${GLIBC_TARBALL}"
GCC_URL="http://mirrors.ustc.edu.cn/gnu/gcc/${GCC_VER}/${GCC_TARBALL}"
GMP_URL="http://mirrors.ustc.edu.cn/gnu/gmp/${GMP_TARBALL}"
MPC_URL="ftp://gcc.gnu.org/pub/gcc/infrastructure/${MPC_TARBALL}"
MPFR_URL="http://mirrors.ustc.edu.cn/gnu/mpfr/${MPFR_TARBALL}"
ISL_URL="ftp://gcc.gnu.org/pub/gcc/infrastructure/${ISL_TARBALL}"
LINUX_URL="http://mirrors.ustc.edu.cn/kernel.org/linux/kernel/${LINUX_MAJOR_VER}/${LINUX_TARBALL}"
GETTEXT_URL="http://mirrors.ustc.edu.cn/gnu/gettext/${GETTEXT_TARBALL}"
# source-qemu
PKGCONFIGLITE_VER=pkg-config-lite-0.28-1
LIBFFI_VER=libffi-3.2.1
GLIB_VER=glib-2.47.5
PIXMAN_VER=pixman-0.32.8
QEMU_VER=qemu-2.5.0
PKGCONFIGLITE_TARBALL="${PKGCONFIGLITE_VER}.tar.gz"
LIBFFI_TARBALL="${LIBFFI_VER}.tar.gz"
GLIB_TARBALL="${GLIB_VER}.tar.xz"
PIXMAN_TARBALL="${PIXMAN_VER}.tar.gz"
QEMU_TARBALL="${QEMU_VER}.tar.bz2"
PKGCONFIGLITE_URL="http://sourceforge.net/projects/pkgconfiglite/files/`echo ${PKGCONFIGLITE_VER} | sed 's/pkg-config-lite-//g'`/${PKGCONFIGLITE_TARBALL}"
LIBFFI_URL="ftp://sourceware.org/pub/libffi/${LIBFFI_TARBALL}"
GLIB_URL="http://mirrors.ustc.edu.cn/gnome/sources/glib/`echo ${GLIB_VER} | sed -e 's/glib-//g' -e 's/\.[^.]*$//g'`/${GLIB_TARBALL}"
PIXMAN_URL="http://cairographics.org/releases/${PIXMAN_TARBALL}"
QEMU_URL="http://wiki.qemu-project.org/download/${QEMU_TARBALL}"
# source - tinylinux
BUSYBOX_VER=busybox-1.24.1
BASH_VER=bash-4.3.30
BUSYBOX_TARBALL="${BUSYBOX_VER}.tar.bz2"
BASH_TARBALL="${BASH_VER}.tar.gz"
BUSYBOX_URL="http://busybox.net/downloads/${BUSYBOX_TARBALL}"
BASH_URL="http://mirrors.ustc.edu.cn/gnu/bash/${BASH_TARBALL}"



# flags
MAKE_FLAGS=-j8

# target
TARGET=arm-unknown-linux-gnueabi
CROSSGCC_EXTRA_CONFIGURE="--with-arch=armv7-a --with-float=soft"
LINUX_ARCH=arm
QEMU_TARGET_LIST=arm-softmmu
QEMU_CMDLINE="qemu-system-arm -M vexpress-a9 -m 1024 -dtb ${LINUX_VER}/arch/arm/boot/dts/vexpress-v2p-ca9.dtb -kernel ${LINUX_VER}/arch/arm/boot/zImage -initrd initramfs -serial stdio -append 'console=ttyAMA0 console=tty0'"


# functions

function fail()
{
    echo "fail: $@"
    exit 1
}

function chdir_to()
{
    mkdir -p "$@" && cd "$@" || fail "can't chdir to $@"
}

function download_file_by_curl()
{
    echo "download: $1"
    curl -fLRO "$1" || fail "can't download $1"
}

function download_file()
{
    echo "download: $1"
    wget -t 0 -c "$1" || fail "can't download $1"
}

function unpack_file()
{
    echo "unpack: $@"
    if [[ "$@" =~ \.xz$ ]]; then
        echo "xzcat: $@"
        xzcat "$@" | tar x || fail "can't unpack $@"
    else
        tar xf "$@" || fail "can't unpack $@"
    fi
}

function standard_build()
{
    chdir_to "$1"
    make distclean
    ./configure "--prefix=$2" $3 && make ${MAKE_FLAGS} && make install || fail "can't build in $1"
}

function export_native_gcc_path()
{
    export PATH="${GCC_NATIVE_PREFIX}/bin:${PATH}"
}

function export_cross_toolchain_path()
{
    export PATH="${GCC_CROSS_PREFIX}/bin:${PATH}"
}

function export_util_path()
{
    export PATH="${UTIL_PREFIX}/bin:${PATH}"
}

function export_lib_path()
{
    export PATH="${LIB_PREFIX}/bin:${PATH}"
}

function save_path()
{
    SAVED_PATH="$PATH"
}

function restore_path()
{
    export PATH="${SAVED_PATH}"
}

set -o pipefail

