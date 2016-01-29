#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

chdir_to "${UTIL_SRC}"

${UTIL_PREFIX}/bin/awk --version || (unpack_file "${SRC}/${AWK_TARBALL}" && standard_build "${UTIL_SRC}/${AWK_VER}" "${UTIL_PREFIX}")
${UTIL_PREFIX}/bin/sed --version || (unpack_file "${SRC}/${SED_TARBALL}" && standard_build "${UTIL_SRC}/${SED_VER}" "${UTIL_PREFIX}")
${UTIL_PREFIX}/bin/xz --version || (unpack_file "${SRC}/${XZ_TARBALL}" && standard_build "${UTIL_SRC}/${XZ_VER}" "${UTIL_PREFIX}")
${UTIL_PREFIX}/bin/find --version || (unpack_file "${SRC}/${FINDUTILS_TARBALL}" && standard_build "${UTIL_SRC}/${FINDUTILS_VER}" "${UTIL_PREFIX}")

exit 0

