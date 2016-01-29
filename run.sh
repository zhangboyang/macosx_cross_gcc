#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

gen_setpath_script
$DIR/wget.sh || fail "wget.sh failed"
$DIR/download.sh || fail "download.sh failed"
$DIR/util.sh || fail "util.sh failed"
$DIR/toolchain.sh || fail "toolchain.sh failed"
$DIR/qemu.sh || fail "qemu.sh failed"
$DIR/tinylinux.sh || fail "tinylinux.sh failed"

echo "all finished."

exit 0

