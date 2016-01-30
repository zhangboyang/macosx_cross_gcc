#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

function gen_setpath_script()
{
    cat > "${PREFIX}/set_native_gcc_path.sh" << EOF
#!/bin/sh
export PATH="${GCC_NATIVE_PREFIX}/bin:\${PATH}"
PS1="[NATIVE] \$PS1"
EOF
    cat > "${PREFIX}/set_cross_toolchain_path.sh" << EOF
#!/bin/sh
export PATH="${GCC_CROSS_PREFIX}/bin:\${PATH}"
PS1="[CROSS] \$PS1"
EOF
    cat > "${PREFIX}/set_util_path.sh" << EOF
#!/bin/sh
export PATH="${UTIL_PREFIX}/bin:\${PATH}"
PS1="[UTIL] \$PS1"
EOF
    chmod +x "${PREFIX}/set_native_gcc_path.sh" "${PREFIX}/set_cross_toolchain_path.sh" "${PREFIX}/set_util_path.sh"
}

function gen_qemu_script()
{
    cat > "${PREFIX}/run_qemu.sh" << EOF
#!/bin/sh
export PATH="${UTIL_PREFIX}/bin:\${PATH}"
cd "${TINYLINUX_SRC}" && \
${QEMU_CMDLINE}
EOF
    cat > "${PREFIX}/gen_initramfs.sh" << EOF
#!/bin/sh
cd "${CROSS_SYSROOT}" && \
find . | cpio -H newc -o | gzip > ${TINYLINUX_SRC}/initramfs
EOF
    chmod +x "${PREFIX}/run_qemu.sh" "${PREFIX}/gen_initramfs.sh"
}


gen_setpath_script
gen_qemu_script

$DIR/wget.sh || fail "wget.sh failed"
$DIR/download.sh || fail "download.sh failed"
$DIR/util.sh || fail "util.sh failed"
$DIR/toolchain.sh || fail "toolchain.sh failed"
$DIR/qemu.sh || fail "qemu.sh failed"
$DIR/tinylinux.sh || fail "tinylinux.sh failed"

echo "backup sysroot: ${CROSS_SYSROOT}"
tar cf sysroot-backup.tar ${CROSS_SYSROOT}

echo "all finished."

exit 0

