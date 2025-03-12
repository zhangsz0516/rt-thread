## musl gcc 工具链

下载地址 [https://download.rt-thread.org/download/rt-smart/toolchains/riscv64gc-linux-musleabi_for_x86_64-pc-linux-gnu_237972-b7b57cd165.tar.bz2](https://download.rt-thread.org/download/rt-smart/toolchains/riscv64gc-linux-musleabi_for_x86_64-pc-linux-gnu_237972-b7b57cd165.tar.bz2)


- 下载 musl gcc 工具链后，解压到指定目录，如 `/home/zhangsz/apps/tools/`，解压缩命令 `tar xjf riscv64gc-linux-musleabi_for_x86_64-pc-linux-gnu_237972-b7b57cd165.tar.bz2 -C /home/zhangsz/apps/tools/`


## 设置 musl gcc 工具链环境变量

- ubuntu 20.04 环境，新建 `env_riscv.sh`，内容如下，并设置 shell 脚本的执行权限 `chmod 777 env_riscv.sh`

```bash
#!/bin/bash

export RTT_CC=gcc
export RTT_EXEC_PATH=/home/zhangsz/apps/tools/riscv64gc-linux-musleabi_for_x86_64-pc-linux-gnu/bin
export RTT_CC_PREFIX=riscv64-unknown-linux-musl-

# export RTT_EXEC_PATH
export PATH=$PATH:$RTT_EXEC_PATH
echo "CC        => ${RTT_CC}"
echo "PREFIX    => ${RTT_CC_PREFIX}"
echo "EXEC_PATH => ${RTT_EXEC_PATH}"

```

## 开启 T-Smart

- 进入 `rt-thread/bsp/qemu-virt64-riscv` 目录，运行 `scons --menuconfig` 或者 `source ~/.env/env.sh` `menuconfig` 配置使能 smart，如果出现缺少 `kconfiglib` 错误，需要安装 kconfiglib `pip3 install kconfiglib`

- 选择 RT-Smart 后，保存配置，然后 `scons -j8` 进行编译

- 运行 `./run.sh` 脚本运行，运行信息如下

```c
OpenSBI v1.0
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name             : riscv-virtio,qemu
Platform Features         : medeleg
Platform HART Count       : 1
Platform IPI Device       : aclint-mswi
Platform Timer Device     : aclint-mtimer @ 10000000Hz
Platform Console Device   : uart8250
Platform HSM Device       : ---
Platform Reboot Device    : sifive_test
Platform Shutdown Device  : sifive_test
Firmware Base             : 0x80000000
Firmware Size             : 252 KB
Runtime SBI Version       : 0.3

Domain0 Name              : root
Domain0 Boot HART         : 0
Domain0 HARTs             : 0*
Domain0 Region00          : 0x0000000002000000-0x000000000200ffff (I)
Domain0 Region01          : 0x0000000080000000-0x000000008003ffff ()
Domain0 Region02          : 0x0000000000000000-0xffffffffffffffff (R,W,X)
Domain0 Next Address      : 0x0000000080200000
Domain0 Next Arg1         : 0x000000008fe00000
Domain0 Next Mode         : S-mode
Domain0 SysReset          : yes

Boot HART ID              : 0
Boot HART Domain          : root
Boot HART ISA             : rv64imafdcsuh
Boot HART Features        : scounteren,mcounteren,mcountinhibit,time
Boot HART PMP Count       : 16
Boot HART PMP Granularity : 4
Boot HART PMP Address Bits: 54
Boot HART MHPM Count      : 16
Boot HART MIDELEG         : 0x0000000000001666
Boot HART MEDELEG         : 0x0000000000f0b509
heap: [0x0032c560 - 0x0432c560]

 \ | /
- RT -     Thread Smart Operating System
 / | \     5.2.0 build Mar 12 2025 14:09:59
 2006 - 2024 Copyright by RT-Thread team
lwIP-2.0.3 initialized!
[I/sal.skt] Socket Abstraction Layer initialize success.
[I/utest] utest is initialize success.
[I/utest] total utest testcase num: (1)
[I/drivers.serial] Using /dev/ttyS0 as default console
[W/DFS.fs] mount / failed with file system type: elm
file system initialization done!
Hello RISC-V
msh />

```

## 文件系统 ext4

- menuconfig 开启在线软件包 `lwext4`，选择 `v2.0.0-dfsv2` 分支，并下载 `lwext4`，`source ~/.env/env.sh`，使用 env `pkgs --update` 下载在线软件包 `lwext4`

- 修改 `applications/mnt.c`， 文件系统挂载格式 `elm` 改为 `ext`

- `sd.bin` 改为 `ext4` 格式 `mkfs.ext4 sd.bin`


## 静态链接的 elf

- 编译时可以不指定链接脚本，拷贝到文件系统镜像下运行。

## 动态链接的 elf

- 编译时可以不指定链接脚本

- 拷贝 musl gcc 工具链下的 libc.so 到 文件系统 `/lib/libc.so`

- 为文件系统 `/lib/libc.so` 创建软链接， `sudo ln -s libc.so ld-musl-aarch64.so.1`

- 复制 sdk 下的 `librtthread.so` 到 文件系统 `/lib/librtthread.so`

- 复制 elf 依赖的动态库 `xx.so` 到 文件系统 `/lib` 目录下

