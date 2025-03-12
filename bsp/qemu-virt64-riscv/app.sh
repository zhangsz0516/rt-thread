#!/bin/bash

sudo mkdir sd
sudo mount sd.bin sd
sudo mkdir sd/lib sd/bin
sudo cp -v /home/zhangsz/apps/tools/arm-linux-musleabi_for_x86_64-pc-linux-gnu/arm-linux-musleabi/lib/libc.so sd/lib/
cd sd/lib
sudo ln -s libc.so ld-musl-arm.so.1
cd ../../
sudo cp -rfv /home/zhangsz/smart/rtthread-smart/userapps/root/bin/* sd/bin/
sudo cp -v /home/zhangsz/smart/rtthread-smart/userapps/apps/dl_test/*.elf sd/
sudo cp -v /home/zhangsz/smart/rtthread-smart/userapps/apps/dl_test/build/*.so sd/lib/
sudo cp -v /home/zhangsz/smart/rtthread-smart/userapps/sdk/rt-thread/lib/arm/cortex-a/*.so sd/lib/
sudo cp -v /home/zhangsz/smart/rtthread-smart/userapps/sdk/lib/arm/cortex-a/*.so sd/lib
sudo cp -v /home/zhangsz/smart/rtthread-smart/userapps/root/bin sd/
sudo umount sd
