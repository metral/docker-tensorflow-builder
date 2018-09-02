#!/bin/bash
curl -v -L "https://www.dropbox.com/s/rhcb7jr6o5h8in7/nccl_2.2.13-1%2Bcuda9.2_x86_64.txz" -o /tmp/nccl.txz
tar -xf /tmp/nccl.txz
mv nccl* nccl
cp -R nccl/include/* /usr/local/cuda/include/
mkdir -p /usr/local/cuda/lib && cp -R nccl/lib/* /usr/local/cuda/lib/
