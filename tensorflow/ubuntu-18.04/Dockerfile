#FROM nvidia/cuda:9.2-cudnn7-runtime-ubuntu16.04
FROM ubuntu:16.04

ENV TF_VERSION_GIT_TAG=v1.10.1
ENV PYTHON_VERSION=3.6.5
ENV CUDA_SERIES=9.2
ENV CUDA_VERSION=9.2.148_396.37

RUN apt-get update && apt-get install -y --no-install-recommends \
	build-essential \
	#cuda-command-line-tools-9-2 \
	#cuda-cublas-dev-9-2 \
	#cuda-cudart-dev-9-2 \
	#cuda-cufft-dev-9-2 \
	#cuda-curand-dev-9-2 \
	#cuda-cusolver-dev-9-2 \
	#cuda-cusparse-dev-9-2 \
	curl \
	git \
	#libcudnn7=7.2.1.38-1+cuda9.2 \
	#libcudnn7-dev=7.2.1.38-1+cuda9.2 \
    #libnccl2=2.2.13-1+cuda9.2 \
	#libnccl-dev=2.2.13-1+cuda9.2 \
	libcurl3-dev \
	libfreetype6-dev \
	libhdf5-serial-dev \
	libpng12-dev \
	libzmq3-dev \
	pkg-config \
	rsync \
	software-properties-common \
	unzip \
	zip \
	zlib1g-dev \
	wget \
	&& \
	rm -rf /var/lib/apt/lists/*
    #rm -rf /var/lib/apt/lists/* && \
    #find /usr/local/cuda/lib64/ -type f -name 'lib*_static.a' -not -name 'libcudart_static.a' -delete && \
    #rm /usr/lib/x86_64-linux-gnu/libcudnn_static_v7.a

# Install bazel
RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list && \
    curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update && \
    apt-get install -y bazel

# Install Anaconda
WORKDIR /
RUN wget "https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O "miniconda.sh" && \
    bash "miniconda.sh" -b -p "/conda" && \
    rm miniconda.sh && \
    echo PATH='/conda/bin:$PATH' >> /root/.bashrc && \
    /conda/bin/conda config --add channels conda-forge && \
    /conda/bin/conda update --yes -n base conda && \
    /conda/bin/conda update --all --yes

RUN curl -v -L "https://developer.nvidia.com/compute/cuda/${CUDA_SERIES}/Prod2/local_installers/cuda_${CUDA_VERSION}_linux" -o /tmp/cuda-run
RUN chmod +x /tmp/cuda-run
RUN /tmp/cuda-run --extract=/opt/cuda/${CUDA_VERSION} --toolkit --toolkitpath=/usr/local/cuda --verbose --silent

RUN mkdir -p $HOME/tmp
RUN /opt/cuda/${CUDA_VERSION}/cuda-linux*.run -noprompt -prefix=/usr/local/cuda-${CUDA_VERSION} -tmpdir=$HOME/tmp
RUN rm -rf $HOME/tmp

# Install cuDNN v7.2.1 x86_64 for CUDA 9.2 from DropBox
RUN wget -O cudnn.tgz "https://www.dropbox.com/s/bvk270sl1n13w83/cudnn-9.2-linux-x64-v7.2.1.38.tgz"
RUN tar -xzvf cudnn.tgz
RUN cp cuda/include/cudnn.h /usr/local/cuda/include
RUN cp cuda/lib64/libcudnn* /usr/local/cuda/lib64
RUN chmod a+r /usr/local/cuda/include/cudnn.h /usr/local/cuda/lib64/libcudnn*

# Link NCCL libray and header where the build script expects them.
#RUN mkdir /usr/local/cuda/lib &&  \
#	ln -s /usr/lib/x86_64-linux-gnu/libnccl.so.2 /usr/local/cuda/lib/libnccl.so.2 && \
#    ln -s /usr/include/nccl.h /usr/local/cuda/include/nccl.h

# Install NCCL
RUN curl -v -L "https://www.dropbox.com/s/rhcb7jr6o5h8in7/nccl_2.2.13-1%2Bcuda9.2_x86_64.txz" -o /tmp/nccl.txz
RUN tar -xf /tmp/nccl.txz
RUN mv nccl* nccl
RUN cp -R nccl/include/* /usr/local/cuda/include/
RUN mkdir -p /usr/local/cuda/lib && cp -R nccl/lib/* /usr/local/cuda/lib/

RUN find / -name libcuda.so*
RUN /conda/bin/conda create --yes -n tensorflow python==$PYTHON_VERSION
RUN /bin/bash -c "source /conda/bin/activate tensorflow"
RUN /conda/bin/conda install --yes numpy wheel
COPY build.sh /build.sh
RUN chmod +x /build.sh && /build.sh

CMD /bin/bash
