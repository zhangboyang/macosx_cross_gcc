# macosx_cross_gcc
scripts to make cross compile toolchain on apple mac os x
一组用来在 Mac OS X 系统上从源代码构建交叉编译工具链的脚本

脚本功能：
    在 Mac OS X 平台上，从源代码构建交叉编译工具链 (基于 glibc)
    除此之外，完成后还会编译安装 QEMU 模拟器，编译内核并构建一个迷你 Linux 系统

安装说明：
    1. 准备工作
      (1) 系统要求
           约 20 GB 空余磁盘空间
           接入国际互联网
           接上电源（如果是笔记本）
      (2) 安装 Xcode 命令行开发工具（即使已经安装 Xcode 仍需进行此步骤）
           xcode-select --install
      (3) 创建大小写敏感的磁盘映像（安装 Linux 内核头文件和编译内核需要大小写敏感环境）
           hdiutil create -type SPARSE -fs 'Case-sensitive Journaled HFS+' -size 60g -volname cross-tools crosstools
      (4) 挂载刚创建的磁盘映像
           hdiutil attach crosstools.sparseimage

    2. 配置
         使用文本编辑器编辑 common.sh，在约 100 行的位置可以对工具链和脚本的行为进行配置
           MAKE_FLAGS: 调用 make 命令的额外参数，默认 -j8 表示 8 路并行构建
           TARGET: 工具链的目标平台，默认为 arm-unknown-linux-gnueabi
           CROSSGCC_EXTRA_CONFIGURE: 编译 GCC 时的额外配置
           LINUX_ARCH: 安装 Linux 内核头文件和编译内核时 ARCH 变量的值
           QEMU_TARGET_LIST: QEMU 模拟器的目标平台列表
           QEMU_CMDLINE: 执行 QEMU 的命令行

    3. 安装
      (1) 切换目录到刚创建的磁盘映像
           cd /Volumes/cross-tools
      (2) 执行脚本
           脚本的路径/install.sh

    4. 脚本下载并编译所需的程序大约需要 5 个小时
       执行过程中可能会有 "未安装 javac" 的提示弹出，关闭即可
       全部执行完毕后脚本会显示 "all finished."

使用说明：
    脚本会在磁盘映像里生成一个名为 CrossToolsLauncher 的图标
    双击该图标会打开一个已经配置好环境变量的终端，提示符前会有 [UTIL] [CROSS] 字样
    使用 ${TARGET}-gcc 可以调用 GCC
    使用 ${TARGET}-g++ 可以调用 G++
    导出的变量的说明：
      TARGET: 工具链的目标平台
      SYSROOT: 迷你 Linux 系统的根目录

QEMU 模拟器：
    在配置好环境变量的终端中：
      使用 gen_initramfs.sh 构建迷你 Linux 系统的内存文件系统映像
      使用 run_qemu.sh 可以 QEMU 模拟运行构建出的迷你 Linux 系统

生成的文件和目录的说明：
    CrossToolsLauncher: 用来打开配置好环境变量的终端的小程序
    gcc-cross: 交叉编译工具链所在目录
    gcc-native: 原生 gcc 编译器所在目录
    libs: 编译 QEMU 用到的库的安装目录
    scripts: 一些有用的小脚本的所在目录
    src: 源码和编译临时文件所在目录
    sysroot: 迷你 Linux 系统的根目录
    sysroot-backup.tar: 迷你 Linux 系统的根目录的备份
    utils: 有用的工具（例如 GNU sed, GNU awk, QEMU）的所在目录

卸载方法：
    卸载只要直接删除掉整个磁盘映像就可以了

