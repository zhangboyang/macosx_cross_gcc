#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$DIR/common.sh"

# target
TARGET=arm-unknown-linux-gnueabi
LINUX_ARCH=arm

function build_native_gettext()
{
	chdir_to "${NATIVE_SRC}/${GETTEXT_VER}"
	make distclean
	./configure "--prefix=${GCC_NATIVE_PREFIX}" --disable-java --disable-native-java && make ${MAKE_FLAGS} && make install || fail "can't build gettext"
}

function build_native_gcc()
{
	ln -sf "${NATIVE_SRC}/${GMP_VER}" "${NATIVE_SRC}/${GCC_VER}/gmp" && \
	ln -sf "${NATIVE_SRC}/${MPFR_VER}" "${NATIVE_SRC}/${GCC_VER}/mpfr" && \
	ln -sf "${NATIVE_SRC}/${MPC_VER}" "${NATIVE_SRC}/${GCC_VER}/mpc" && \
	ln -sf "${NATIVE_SRC}/${ISL_VER}" "${NATIVE_SRC}/${GCC_VER}/isl" || fail "can't link library code to gcc directory"

	chdir_to "${NATIVE_SRC}/${GCC_VER}-build"
	make distclean
	"${NATIVE_SRC}/${GCC_VER}/configure" "--prefix=${GCC_NATIVE_PREFIX}" --enable-languages=c,c++ && make ${MAKE_FLAGS} && make install || fail "can't build native-gcc"
}

function unpack_source()
{
	chdir_to "${NATIVE_SRC}"
	unpack_file "${SRC}/${GCC_TARBALL}"
	unpack_file "${SRC}/${GMP_TARBALL}"
	unpack_file "${SRC}/${MPC_TARBALL}"
	unpack_file "${SRC}/${MPFR_TARBALL}"
	unpack_file "${SRC}/${ISL_TARBALL}"
	
	unpack_file "${SRC}/${GETTEXT_TARBALL}"

	chdir_to "${CROSS_SRC}"
	unpack_file "${SRC}/${GCC_TARBALL}"
	unpack_file "${SRC}/${GMP_TARBALL}"
	unpack_file "${SRC}/${MPC_TARBALL}"
	unpack_file "${SRC}/${MPFR_TARBALL}"
	unpack_file "${SRC}/${ISL_TARBALL}"

	unpack_file "${SRC}/${LINUX_TARBALL}"
	unpack_file "${SRC}/${BINUTILS_TARBALL}"
	unpack_file "${SRC}/${GLIBC_TARBALL}"
	
	chdir_to "${CROSS_SRC}/${GCC_VER}-final"
	unpack_file "${SRC}/${GCC_TARBALL}"
	unpack_file "${SRC}/${GMP_TARBALL}"
	unpack_file "${SRC}/${MPC_TARBALL}"
	unpack_file "${SRC}/${MPFR_TARBALL}"
	unpack_file "${SRC}/${ISL_TARBALL}"
}

function export_native_gcc()
{
	export CC="${GCC_NATIVE_PREFIX}/bin/gcc"
	export CXX="${GCC_NATIVE_PREFIX}/bin/g++"	
	export CPP="${GCC_NATIVE_PREFIX}/bin/cpp"
}

function export_cross_gcc()
{
	export CC="${GCC_CROSS_PREFIX}/bin/${TARGET}-gcc"
	export CXX="${GCC_CROSS_PREFIX}/bin/${TARGET}-g++"	
	export CPP="${GCC_CROSS_PREFIX}/bin/${TARGET}-cpp"	
}

function build_cross_binutils()
{
	chdir_to "${CROSS_SRC}/${BINUTILS_VER}-build"
	make distclean
	"${CROSS_SRC}/${BINUTILS_VER}/configure" "--prefix=${GCC_CROSS_PREFIX}" "--target=${TARGET}" "--with-sysroot=${CROSS_SYSROOT}" && make ${MAKE_FLAGS} && make install || fail "can't build cross-binutils"
}

function build_cross_gcc()
{
	ln -sf "${CROSS_SRC}/${GMP_VER}" "${CROSS_SRC}/${GCC_VER}/gmp" && \
	ln -sf "${CROSS_SRC}/${MPFR_VER}" "${CROSS_SRC}/${GCC_VER}/mpfr" && \
	ln -sf "${CROSS_SRC}/${MPC_VER}" "${CROSS_SRC}/${GCC_VER}/mpc" && \
	ln -sf "${CROSS_SRC}/${ISL_VER}" "${CROSS_SRC}/${GCC_VER}/isl" || fail "can't link library code to gcc directory"

	chdir_to "${CROSS_SRC}/${GCC_VER}-build"
	make distclean
	"${CROSS_SRC}/${GCC_VER}/configure" \
		"--prefix=${GCC_CROSS_PREFIX}" \
		"--target=${TARGET}" \
		"--with-sysroot=${CROSS_SYSROOT}" \
		--enable-languages=c,c++ \
		--with-newlib \
		--disable-threads \
		--disable-shared \
		--without-headers && \
	make ${MAKE_FLAGS} all-gcc all-target-libgcc && \
	make install-gcc install-target-libgcc || fail "can't build cross-gcc"
}

function build_cross_glibc()
{
	chdir_to "${CROSS_SRC}/${GLIBC_VER}-build"
	make distclean
	BUILD_CC="gcc -lintl" "${CROSS_SRC}/${GLIBC_VER}/configure" \
		--prefix=/usr \
		"--host=${TARGET}" \
		"--with-headers=${CROSS_SYSROOT}/usr/include" \
		--enable-obsolete-rpc && \
	make ${MAKE_FLAGS} && make "install_root=${CROSS_SYSROOT}" "DESTDIR={SYSROOT}" install || fail "can't build cross-glibc"
}

function build_cross_gcc_final()
{
	ln -sf "${CROSS_SRC}/${GCC_VER}-final/${GMP_VER}" "${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}/gmp" && \
	ln -sf "${CROSS_SRC}/${GCC_VER}-final/${MPFR_VER}" "${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}/mpfr" && \
	ln -sf "${CROSS_SRC}/${GCC_VER}-final/${MPC_VER}" "${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}/mpc" && \
	ln -sf "${CROSS_SRC}/${GCC_VER}-final/${ISL_VER}" "${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}/isl" || fail "can't link library code to gcc directory"

	chdir_to "${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}-build"
	make distclean
	"${CROSS_SRC}/${GCC_VER}-final/${GCC_VER}/configure" \
		"--prefix=${GCC_CROSS_PREFIX}" \
		"--target=${TARGET}" \
		"--with-sysroot=${CROSS_SYSROOT}" \
		--enable-languages=c,c++ \
		--enable-__cxa_atexit \
		--enable-threads=posix \
		--enable-libstdcxx-time && \
	make ${MAKE_FLAGS} && \
	make install || fail "can't build cross-gcc-final"
}

function install_linux_headers()
{
	chdir_to "${CROSS_SRC}/${LINUX_VER}"
	make "ARCH=${LINUX_ARCH}" "INSTALL_HDR_PATH=${CROSS_SYSROOT}/usr" headers_install || fail "can't install linux-headers"
}

function build_native_part()
{
	build_native_gcc

	export_native_gcc
	build_native_sed
	build_native_awk
	build_native_gettext
}

function build_cross_part()
{
	export_native_gcc
	build_cross_binutils
	build_cross_gcc
    install_linux_headers
	
	export_cross_gcc
	build_cross_glibc
	
	export_native_gcc
	build_cross_gcc_final
}


# build glibc need this
ulimit -n 1024

# unpack source
unpack_source

# set PATH
export_path
gen_setpath_script

# build native tools
build_native_part

# build cross tools
build_cross_part

exit 0

