FROM nvidia/cuda:9.2-cudnn7-runtime-ubuntu18.04

ENV TF_VERSION_GIT_TAG=v1.10.1
ENV PYTHON_VERSION=3.7.0
ENV CUDA_SERIES=9.2
ENV CUDA_VERSION=9.2.148_396.37
ENV NCCL_VERSION 2.2.12

RUN apt update && apt install -y \
    build-essential \
    curl \
    git \
    wget \
    #libjpeg-dev \
    #openjdk-8-jdk \
    && rm -rf /var/lib/lists/*

# Install Anaconda
WORKDIR /
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "miniconda.sh" && \
    bash "miniconda.sh" -b -p "/conda" && \
    rm miniconda.sh && \
    echo PATH='/conda/bin:$PATH' >> /root/.bashrc && \
    /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes

#COPY setup_cuda.sh /setup_cuda.sh
#RUN chmod +x /setup.sh && /setup_cuda.sh

RUN mkdir -p /opt/cuda/${CUDA_VERSION}
RUN curl -v -L "https://developer.nvidia.com/compute/cuda/${CUDA_SERIES}/Prod2/local_installers/cuda_${CUDA_VERSION}_linux" -o /tmp/cuda-run
RUN chmod +x /tmp/cuda-run
RUN /tmp/cuda-run --extract=/opt/cuda/${CUDA_VERSION} --toolkit --toolkitpath=/opt/cuda/${CUDA_VERSION} --verbose --silent

RUN ln -sf /opt/cuda/${CUDA_VERSION} /opt/cuda/current
RUN mkdir -p $HOME/tmp
RUN /opt/cuda/current/cuda-linux*.run -noprompt -prefix=/opt/cuda/current -tmpdir=$HOME/tmp
RUN rm -rf $HOME/tmp

# Install cuDNN v7.2.1 x86_64 for CUDA 9.2 from DropBox
RUN wget -O cudnn.tgz "https://www.dropbox.com/s/bvk270sl1n13w83/cudnn-9.2-linux-x64-v7.2.1.38.tgz"
RUN tar -xzvf cudnn.tgz
RUN cp cuda/include/cudnn.h /usr/local/cuda/include
RUN cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
RUN chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

#RUN curl -v -L "https://www.dropbox.com/s/rhcb7jr6o5h8in7/nccl_2.2.13-1%2Bcuda9.2_x86_64.txz" -o /tmp/nccl.txz
#RUN tar -xf /tmp/nccl.txz
#RUN mv nccl* nccl
#RUN cp -R nccl/include/* /opt/cuda/${CUDA_VERSION}/include/
#RUN cp -R nccl/lib/* /opt/cuda/${CUDA_VERSION}/lib64/

# Link NCCL libray and header where the build script expects them.
RUN apt-get install -y libnccl2=2.2.13-1+cuda9.2 libnccl-dev=2.2.13-1+cuda9.2
RUN find / -name libnccl.so*
RUN find / -name nccl.h
RUN mkdir /usr/local/cuda/lib &&  \
	ln -s /usr/lib/x86_64-linux-gnu/libnccl.so.2 /usr/local/cuda/lib/libnccl.so.2 && \
    ln -s /usr/include/nccl.h /usr/local/cuda/include/nccl.h

COPY build.sh /build.sh
RUN chmod +x /build.sh && /build.sh

CMD /bin/bash
