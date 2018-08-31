#!/bin/bash

# Install CUDA 
mkdir -p /opt/cuda/${CUDA_VERSION}
curl -v -L "https://developer.nvidia.com/compute/cuda/${CUDA_SERIES}/Prod2/local_installers/cuda_${CUDA_VERSION}_linux" -o /tmp/cuda-run
chmod +x /tmp/cuda-run
/tmp/cuda-run --extract=/opt/cuda/${CUDA_VERSION} --toolkit --toolkitpath=/opt/cuda/${CUDA_VERSION} --verbose --silent

ln -sf /opt/cuda/${CUDA_VERSION} /opt/cuda/current
mkdir -p $HOME/tmp
/opt/cuda/current/cuda-linux*.run -noprompt -prefix=/opt/cuda/current -tmpdir=$HOME/tmp
rm -rf $HOME/tmp

# Install cuDNN v7.2.1 x86_64 for CUDA 9.2 from DropBox
wget -O cudnn.tgz "https://www.dropbox.com/s/bvk270sl1n13w83/cudnn-9.2-linux-x64-v7.2.1.38.tgz"
tar -xzvf cudnn.tgz
cp cuda/include/cudnn.h /usr/local/cuda/include
cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# Install NCCL
curl -v -L "https://www.dropbox.com/s/rhcb7jr6o5h8in7/nccl_2.2.13-1%2Bcuda9.2_x86_64.txz" -o /tmp/nccl.txz
tar -xf /tmp/nccl.txz
mv nccl* nccl
cp -R nccl/include/* /opt/cuda/${CUDA_VERSION}/include/
cp -R nccl/lib/* /opt/cuda/${CUDA_VERSION}/lib64/
