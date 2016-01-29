#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

chdir_to "${UTIL_SRC}"
download_file_by_curl "${WGET_URL}"
unpack_file "${SRC}/${WGET_TARBALL}"
standard_build "${UTIL_SRC}/${WGET_VER}" "${UTIL_PREFIX}"

exit 0

