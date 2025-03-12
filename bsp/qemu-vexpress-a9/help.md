## musl gcc 工具链

下载地址 [https://download.rt-thread.org/download/rt-smart/toolchains/arm-linux-musleabi_for_x86_64-pc-linux-gnu_236309-e8ed057a81.tar.bz2](https://download.rt-thread.org/download/rt-smart/toolchains/arm-linux-musleabi_for_x86_64-pc-linux-gnu_236309-e8ed057a81.tar.bz2)


- 下载 musl gcc 工具链后，解压到指定目录，如 `/home/zhangsz/apps/tools/`，解压缩命令 `tar xjf arm-linux-musleabi_for_x86_64-pc-linux-gnu_236309-e8ed057a81.tar.bz2 -C /home/zhangsz/apps/tools/`


## 设置 musl gcc 工具链环境变量

- ubuntu 20.04 环境，新建 `env_arm.sh`，内容如下，并设置 shell 脚本的执行权限 `chmod 777 env_arm.sh`

```bash
#!/bin/bash

export RTT_CC=gcc
export RTT_EXEC_PATH=/home/zhangsz/apps/tools/arm-linux-musleabi_for_x86_64-pc-linux-gnu/bin
export RTT_CC_PREFIX=arm-linux-musleabi-

# export RTT_EXEC_PATH
export PATH=$PATH:$RTT_EXEC_PATH
echo "CC        => ${RTT_CC}"
echo "PREFIX    => ${RTT_CC_PREFIX}"
echo "EXEC_PATH => ${RTT_EXEC_PATH}"

```

## 开启 smart

- 进入 `rt-thread/bsp/qemu-vexpress-a9` 目录，运行 `scons --menuconfig` 配置使能 smart，如果出现缺少 kconfiglib 错误，需要安装 kconfiglib `pip3 install kconfiglib`

- 选择 smart 后，保存配置，然后 `scons -j8` 进行编译

- 运行 `./qemu.sh` 脚本运行，运行信息如下

```c
 \ | /
- RT -     Thread Smart Operating System
 / | \     5.2.0 build Mar 10 2025 18:03:06
 2006 - 2024 Copyright by RT-Thread team
[I/drivers.serial] Using /dev/ttyS0 as default console
[I/SDIO] SD card capacity 65536 KB.
[I/SDIO] sd: switch to High Speed / SDR25 mode

[I/FileSystem] file system initialization done!

Hello RT-Thread!
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

- 为文件系统 `/lib/libc.so` 创建软链接， `sudo ln -s libc.so ld-musl-arm.so.1`

- 复制 sdk 下的 `librtthread.so` 到 文件系统 `/lib/librtthread.so`

- 复制 elf 依赖的动态库 `xx.so` 到 文件系统 `/lib` 目录下

