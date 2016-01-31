#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/common.sh"

function gen_setpath_script()
{
    cat > "${SCRIPT_PREFIX}/set_native_gcc_path.sh" << EOF
#!/bin/sh
export PATH="${GCC_NATIVE_PREFIX}/bin:\${PATH}"
PS1="[NATIVE] \$PS1"
EOF
    cat > "${SCRIPT_PREFIX}/set_cross_toolchain_path.sh" << EOF
#!/bin/sh
export PATH="${GCC_CROSS_PREFIX}/bin:\${PATH}"
export SYSROOT="${SYSROOT}"
export TARGET="${TARGET}"
export GCC_CROSS_PREFIX="${GCC_CROSS_PREFIX}"
PS1="[CROSS] \$PS1"
EOF
    cat > "${SCRIPT_PREFIX}/set_util_path.sh" << EOF
#!/bin/sh
export PATH="${UTIL_PREFIX}/bin:\${PATH}"
PS1="[UTIL] \$PS1"
EOF
    chmod +x "${SCRIPT_PREFIX}/set_native_gcc_path.sh" "${SCRIPT_PREFIX}/set_cross_toolchain_path.sh" "${SCRIPT_PREFIX}/set_util_path.sh"
}

function gen_qemu_script()
{
    cat > "${SCRIPT_PREFIX}/run_qemu.sh" << EOF
#!/bin/sh
export PATH="${UTIL_PREFIX}/bin:\${PATH}"
cd "${TINYLINUX_SRC}" && \
${QEMU_CMDLINE}
EOF
    cat > "${SCRIPT_PREFIX}/gen_initramfs.sh" << EOF
#!/bin/sh
cd "${SYSROOT}" && \
find . | cpio -H newc -o | gzip > "${TINYLINUX_SRC}/initramfs"
EOF
    chmod +x "${SCRIPT_PREFIX}/run_qemu.sh" "${SCRIPT_PREFIX}/gen_initramfs.sh"
}

function gen_standard_build_script()
{
    cat > "${SCRIPT_PREFIX}/standard_build_for_target.sh" << EOF
#!/bin/sh
make distclean
./configure "--host=${TARGET}" --prefix=/usr \$@ && \
make ${MAKE_FLAGS} && \
make "DESTDIR=${SYSROOT}" install || echo "failed."
EOF
    chmod +x "${SCRIPT_PREFIX}/standard_build_for_target.sh"
    cat > "${SCRIPT_PREFIX}/standard_build_for_host.sh" << EOF
#!/bin/sh
make distclean
./configure "--host=${TARGET}" "--prefix=${GCC_CROSS_PREFIX}" \$@ && \
make ${MAKE_FLAGS} && \
make install || echo "failed."
EOF
    chmod +x "${SCRIPT_PREFIX}/standard_build_for_host.sh"
}

function gen_cross_environment_script()
{
    cat > "${SCRIPT_PREFIX}/cross_environment.sh" << EOF
#!/bin/bash
export PATH="${SCRIPT_PREFIX}:\${PATH}"
/bin/bash --rcfile <(
    echo "cd \"${PREFIX}\""
    echo "source \"${SCRIPT_PREFIX}/set_cross_toolchain_path.sh\""
    echo "source \"${SCRIPT_PREFIX}/set_util_path.sh\""
)
EOF
    chmod +x "${SCRIPT_PREFIX}/cross_environment.sh"
}

function gen_maxosx_app()
{
    cat > "${PREFIX}/CrossToolsLauncher.app" << EOF
#!/bin/bash
open -a Terminal "${SCRIPT_PREFIX}/cross_environment.sh"
EOF
    chmod +x "${PREFIX}/CrossToolsLauncher.app"
}

mkdir -p "${SCRIPT_PREFIX}"
gen_setpath_script
gen_qemu_script
gen_standard_build_script
gen_cross_environment_script
gen_maxosx_app

exit 0

