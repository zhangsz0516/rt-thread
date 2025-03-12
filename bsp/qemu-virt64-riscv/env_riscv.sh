#!/bin/bash

export RTT_CC=gcc
export RTT_EXEC_PATH=/home/zhangsz/apps/tools/riscv64gc-linux-musleabi_for_x86_64-pc-linux-gnu/bin
export RTT_CC_PREFIX=riscv64-unknown-linux-musl-

# export RTT_EXEC_PATH
export PATH=$PATH:$RTT_EXEC_PATH
echo "CC        => ${RTT_CC}"
echo "PREFIX    => ${RTT_CC_PREFIX}"
echo "EXEC_PATH => ${RTT_EXEC_PATH}"
