#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

chdir_to "${UTIL_SRC}"
unpack_file "${SRC}/${SED_TARBALL}"
unpack_file "${SRC}/${AWK_TARBALL}"
unpack_file "${SRC}/${XZ_TARBALL}"
unpack_file "${SRC}/${FINDUTILS_TARBALL}"

standard_build "${UTIL_SRC}/${AWK_VER}" "${UTIL_PREFIX}"
standard_build "${UTIL_SRC}/${SED_VER}" "${UTIL_PREFIX}"
standard_build "${UTIL_SRC}/${XZ_VER}" "${UTIL_PREFIX}"
standard_build "${UTIL_SRC}/${FINDUTILS_VER}" "${UTIL_PREFIX}"

exit 0

