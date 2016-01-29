#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

function export_lib_env()
{
    export PATH="${LIB_PREFIX}/bin:$PATH"
    export CFLAGS="-I${LIB_PREFIX}/include"
    export LDFLAGS="-L${LIB_PREFIX}/lib"
}

chdir_to "${QEMU_SRC}"
unpack_file "${SRC}/${PKGCONFIGLITE_TARBALL}"
unpack_file "${SRC}/${LIBFFI_TARBALL}"
unpack_file "${SRC}/${GETTEXT_TARBALL}"
unpack_file "${SRC}/${GLIB_TARBALL}"
unpack_file "${SRC}/${PIXMAN_TARBALL}"
unpack_file "${SRC}/${QEMU_TARBALL}"

export_lib_env
standard_build "${QEMU_SRC}/${PKGCONFIGLITE_VER}" "${LIB_PREFIX}"
standard_build "${QEMU_SRC}/${LIBFFI_VER}" "${LIB_PREFIX}"
standard_build "${QEMU_SRC}/${GETTEXT_VER}" "${LIB_PREFIX}"
standard_build "${QEMU_SRC}/${GLIB_VER}" "${LIB_PREFIX}" "--with-pcre=internal"
standard_build "${QEMU_SRC}/${PIXMAN_VER}" "${LIB_PREFIX}"
standard_build "${QEMU_SRC}/${QEMU_VER}" "${UTIL_PREFIX}" "--target-list=arm-softmmu"

exit 0
