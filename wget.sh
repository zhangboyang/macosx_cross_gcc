#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

${UTIL_PREFIX}/bin/wget --version && exit 0

chdir_to "${SRC}"
download_file_by_curl "${WGET_URL}"
chdir_to "${UTIL_SRC}"
unpack_file "${SRC}/${WGET_TARBALL}"
standard_build "${UTIL_SRC}/${WGET_VER}" "${UTIL_PREFIX}" "--without-ssl"

exit 0

