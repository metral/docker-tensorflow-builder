#!/usr/bin/env bash
set -e
export PATH="/conda/bin:/usr/bin:$PATH"

ls -alh /usr/local/cuda-9.2.148_396.37/include/nccl.h

# Install an appropriate Python environment
chmod +x /conda/bin/*
#conda create --yes -n tensorflow python==$PYTHON_VERSION
#source activate tensorflow
#conda install --yes numpy wheel bazel
#conda install --yes numpy wheel

# Compile TensorFlow

# Here you can change the TensorFlow version you want to build.
# You can also tweak the optimizations and various parameters for the build compilation.
# See https://www.tensorflow.org/install/install_sources for more details.

cd /
rm -fr tensorflow/
git clone --depth 1 --branch $TF_VERSION_GIT_TAG "https://github.com/metral/tensorflow.git"

TF_ROOT=/tensorflow
cd $TF_ROOT

# Python path options
export PYTHON_BIN_PATH=$(which python)
export PYTHON_LIB_PATH="$($PYTHON_BIN_PATH -c 'import site; print(site.getsitepackages()[0])')"
export PYTHONPATH=${TF_ROOT}/lib
export PYTHON_ARG=${TF_ROOT}/lib

# Compilation parameters
export TF_NEED_CUDA=0
export TF_NEED_GCP=1
export TF_CUDA_COMPUTE_CAPABILITIES=6.1
export TF_NEED_HDFS=1
export TF_NEED_OPENCL=0
export TF_NEED_JEMALLOC=1  # Need to be disabled on CentOS 6.6
export TF_ENABLE_XLA=0
export TF_NEED_VERBS=0
export TF_CUDA_CLANG=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_MKL=0
export TF_DOWNLOAD_MKL=0
export TF_NEED_MPI=0
export TF_NEED_S3=1
export TF_NEED_KAFKA=1
export TF_NEED_GDR=0
export TF_NEED_OPENCL_SYCL=0
export TF_SET_ANDROID_WORKSPACE=0
export TF_NEED_AWS=0

# Compiler options
export GCC_HOST_COMPILER_PATH=$(which gcc)
export CC_OPT_FLAGS="-march=native"

#if [ "$USE_GPU" -eq "1" ]; then
	# Cuda parameters
export CUDA_TOOLKIT_PATH=/usr/local/cuda-${CUDA_VERSION}
export CUDNN_INSTALL_PATH=/usr/local/cuda-${CUDA_VERSION}
export TF_CUDA_VERSION="$CUDA_VERSION"
export TF_CUDNN_VERSION="$CUDNN_VERSION"
export TF_NEED_CUDA=1
export TF_NEED_TENSORRT=0
export TF_NCCL_VERSION=2.2
export NCCL_INSTALL_PATH=/usr/local/cuda-${CUDA_VERSION}

# Those two lines are important for the linking step.
export LD_LIBRARY_PATH="$CUDA_TOOLKIT_PATH/lib64:${LD_LIBRARY_PATH}"
ldconfig
#ls -alh /opt/cuda/9.2.148_396.37/include/nccl.h
#fi

# Compilation
ls -alh /usr/local/cuda-9.2.148_396.37/include/nccl.h
ls -alh /usr/local/cuda-9.2.148_396.37/lib
ls -alh /usr/local/cuda-9.2.148_396.37/lib64
./configure


#if [ "$USE_GPU" -eq "1" ]; then

	bazel build --config=opt \
	    		--config=cuda \
	    		--action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
	    		//tensorflow/tools/pip_package:build_pip_package

#else
#
#	bazel build --config=opt \
#			    --action_env="LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
#			    //tensorflow/tools/pip_package:build_pip_package
#
#fi

# Project name can only be set for TF > 1.8
#PROJECT_NAME="tensorflow_gpu_cuda_${TF_CUDA_VERSION}_cudnn_${TF_CUDNN_VERSION}"
#bazel-bin/tensorflow/tools/pip_package/build_pip_package /wheels --project_name $PROJECT_NAME

bazel-bin/tensorflow/tools/pip_package/build_pip_package /wheels

# Fix wheel folder permissions
chmod -R 777 /wheels/
