#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/common.sh"

"${DIR}/genscript.sh" || fail "genscript.sh failed"
"${DIR}/wget.sh" || fail "wget.sh failed"
"${DIR}/download.sh" || fail "download.sh failed"
"${DIR}/util.sh" || fail "util.sh failed"
"${DIR}/toolchain.sh" || fail "toolchain.sh failed"
"${DIR}/qemu.sh" || fail "qemu.sh failed"
"${DIR}/tinylinux.sh" || fail "tinylinux.sh failed"

echo "backup sysroot: ${SYSROOT}"
cd "`dirname ${SYSROOT}`" && tar cf "${PREFIX}/sysroot-backup.tar" "`basename "${SYSROOT}"`"

echo "all finished."

exit 0

