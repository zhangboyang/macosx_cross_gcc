#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

chdir_to "${SRC}"

# util
function download_util_files()
{
    download_file "${SED_URL}"
    download_file "${AWK_URL}"
    download_file "${XZ_URL}"
}

# toolchain
function download_toolchain_files()
{
    download_file "${BINUTILS_URL}"
    download_file "${GLIBC_URL}"
    download_file "${GCC_URL}"
    download_file "${GMP_URL}"
    download_file "${MPC_URL}"
    download_file "${MPFR_URL}"
    download_file "${ISL_URL}"
    download_file "${LINUX_URL}"
    download_file "${GETTEXT_URL}"
}

# qemu
function download_qemu_files()
{
    download_file "${QEMU_URL}"
    download_file "${PIXMAN_URL}"
    download_file "${PKGCONFIGLITE_URL}"
    download_file "${LIBFFI_URL}"
    download_file "${GLIB_URL}"
    #download_file "${GETTEXT_URL}"
}


export_util_path
download_util_files
download_toolchain_files
download_qemu_files

exit 0

