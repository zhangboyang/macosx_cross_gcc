#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

function fix_elf_h()
{
    cat "${SYSROOT}/usr/include/elf.h" | sed -e '/features\.h/d' -e '/__BEGIN_DECLS/d' -e '/__END_DECLS/d' > "${GCC_NATIVE_PREFIX}/include/elf.h"
}

function build_kernel()
{
    save_path
    export_native_gcc_path
    chdir_to "${TINYLINUX_SRC}/${LINUX_VER}"
    make distclean
    make "ARCH=${LINUX_ARCH}" vexpress_defconfig && \
    make "ARCH=${LINUX_ARCH}" "CROSS_COMPILE=${TARGET}-" all ${MAKE_FLAGS} || fail "can't build kernel"
    restore_path
}

function install_busybox()
{
    chdir_to "${TINYLINUX_SRC}/${BUSYBOX_VER}"
    make distclean
    make "CROSS_COMPILE=${TARGET}-" defconfig && \
    make "CROSS_COMPILE=${TARGET}-" ${MAKE_FLAGS} && \
    make "CROSS_COMPILE=${TARGET}-" "CONFIG_PREFIX=${SYSROOT}" install || fail "can't build busybox"
}

function install_bash()
{
    chdir_to "${TINYLINUX_SRC}/${BASH_VER}"
    make distclean
    ./configure "--host=${TARGET}" --prefix=/ && \
    make ${MAKE_FLAGS} && \
    make "DESTDIR=${SYSROOT}" install || fail "can't build bash"
}

function install_files()
{
    chdir_to "${SYSROOT}"
    ln -s bin/busybox init
    mkdir -p "${SYSROOT}/dev"
    mkdir -p "${SYSROOT}/proc"
    mkdir -p "${SYSROOT}/sys"
    mkdir -p "${SYSROOT}/etc/init.d"
    cat > "${SYSROOT}/etc/init.d/rcS" << EOF
#!/bin/sh
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
mount -t sys sys /sys
EOF
    chmod +x "${SYSROOT}/etc/init.d/rcS"
}

chdir_to "${TINYLINUX_SRC}"
unpack_file "${SRC}/${LINUX_TARBALL}"
unpack_file "${SRC}/${BUSYBOX_TARBALL}"
unpack_file "${SRC}/${BASH_TARBALL}"

export_cross_toolchain_path
export_util_path

fix_elf_h
build_kernel
install_busybox
install_bash
install_files

exit 0

