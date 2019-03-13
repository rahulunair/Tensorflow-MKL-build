FROM ubuntu:bionic

RUN apt-get update  && apt-get install -y\
    ca-certificates \
    build-essential \
    curl \
    git \
    libcurl3-dev \
    libfreetype6-dev \
    libhdf5-serial-dev \
    libzmq3-dev \
    pkg-config \
    rsync \
    software-properties-common \
    unzip \
    zip \
    zlib1g-dev \
    openjdk-8-jdk \
    python3.7-dev \
    python3.7 \
    python3-distutils \
    python3-distutils-extra \
    swig && \
    apt-get clean

RUN curl -O https://bootstrap.pypa.io/get-pip.py &&\
    python3.7 get-pip.py
RUN pip3.7 --no-cache-dir install \
    Pillow \
    h5py \
    keras_applications \
    keras_preprocessing \
    matplotlib \
    mock \
    numpy \
    scipy \
    sklearn \
    pandas \
    enum34

RUN ln -s /usr/bin/python3.7 /usr/local/bin/python
RUN ln -s /usr/bin/python3.7 /usr/bin/python
 # Build and install bazel
ENV BAZEL_VERSION 0.19.0
WORKDIR /
RUN mkdir /bazel && \
    cd /bazel && \
    curl -fSsL -O https://github.com/bazelbuild/bazel/releases/download/$BAZEL_VERSION/bazel-$BAZEL_VERSION-dist.zip && \
    unzip bazel-$BAZEL_VERSION-dist.zip && \
    bash ./compile.sh && \
    cp output/bazel /usr/local/bin/ && \
    rm -rf /bazel && \
    cd -

RUN git clone https://github.com/tensorflow/tensorflow.git /tensorflow_src && \
    cd /tensorflow_src && \
    git checkout v1.13.1

WORKDIR /tensorflow_src
RUN \
  export PYTHON_BIN_PATH=/usr/bin/python3.7 &&\
  export USE_DEFAULT_PYTHON_LIB_PATH=1 &&\
  export CC_OPT_FLAGS="-march=native -mtune=native"  &&\
  export TF_NEED_JEMALLOC=1  &&\
  export TF_NEED_KAFKA=0 &&\
  export TF_NEED_OPENCL_SYCL=0 &&\
  export TF_NEED_GCP=0 &&\
  export TF_NEED_HDFS=0 &&\
  export TF_NEED_S3=0 &&\
  export TF_ENABLE_XLA=1 &&\
  export TF_NEED_GDR=0 &&\
  export TF_NEED_VERBS=0 &&\
  export TF_NEED_OPENCL=0 &&\
  export TF_NEED_MPI=0 &&\
  export TF_NEED_TENSORRT=0 &&\
  export TF_SET_ANDROID_WORKSPACE=0 &&\
  export TF_DOWNLOAD_CLANG=0 &&\
  export TF_NEED_CUDA=0 &&\
  export HTTP_PROXY=`echo $http_proxy | sed -e 's/\/$//'` &&\
  export HTTPS_PROXY=`echo $https_proxy | sed -e 's/\/$//'`

RUN ./configure  &&\
    bazel --output_base=/tmp/bazel build --repository_cache=/tmp/cache  --config=opt --config=mkl --copt=-O3 --jobs $(nproc) --copt=-Wno-sign-compare  --incompatible_remove_native_http_archive=false   //tensorflow/tools/pip_package:build_pip_package &&\
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_builds

RUN \
  export PYTHON_BIN_PATH=/usr/bin/python3.7 &&\
  export USE_DEFAULT_PYTHON_LIB_PATH=1 &&\
  export CC_OPT_FLAGS="-march=native -mtune=native"  &&\
  export TF_NEED_JEMALLOC=1  &&\
  export TF_NEED_KAFKA=0 &&\
  export TF_NEED_OPENCL_SYCL=0 &&\
  export TF_NEED_GCP=0 &&\
  export TF_NEED_HDFS=0 &&\
  export TF_NEED_S3=0 &&\
  export TF_ENABLE_XLA=1 &&\
  export TF_NEED_GDR=0 &&\
  export TF_NEED_VERBS=0 &&\
  export TF_NEED_OPENCL=0 &&\
  export TF_NEED_MPI=0 &&\
  export TF_NEED_TENSORRT=0 &&\
  export TF_SET_ANDROID_WORKSPACE=0 &&\
  export TF_DOWNLOAD_CLANG=0 &&\
  export TF_NEED_CUDA=0 &&\
  export HTTP_PROXY=`echo $http_proxy | sed -e 's/\/$//'` &&\
  export HTTPS_PROXY=`echo $https_proxy | sed -e 's/\/$//'`

RUN bazel clean &&\
    export TF_BUILD_MAVX=MAVX2 &&\
    ./configure  &&\
    mkdir /tmp/avx2 &&\
    bazel --output_base=/tmp/bazel build --repository_cache=/tmp/cache  --config=opt --config=mkl --copt=-O3 --copt=-mavx2 --jobs $(nproc) --copt=-march=haswell --copt=-mfma  --incompatible_remove_native_http_archive=false   //tensorflow/tools/pip_package:build_pip_package &&\
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_builds/avx2/


RUN \
  export PYTHON_BIN_PATH=/usr/bin/python3.7 &&\
  export USE_DEFAULT_PYTHON_LIB_PATH=1 &&\
  export CC_OPT_FLAGS="-march=native -mtune=native"  &&\
  export TF_NEED_JEMALLOC=1  &&\
  export TF_NEED_KAFKA=0 &&\
  export TF_NEED_OPENCL_SYCL=0 &&\
  export TF_NEED_GCP=0 &&\
  export TF_NEED_HDFS=0 &&\
  export TF_NEED_S3=0 &&\
  export TF_ENABLE_XLA=1 &&\
  export TF_NEED_GDR=0 &&\
  export TF_NEED_VERBS=0 &&\
  export TF_NEED_OPENCL=0 &&\
  export TF_NEED_MPI=0 &&\
  export TF_NEED_TENSORRT=0 &&\
  export TF_SET_ANDROID_WORKSPACE=0 &&\
  export TF_DOWNLOAD_CLANG=0 &&\
  export TF_NEED_CUDA=0 &&\
  export HTTP_PROXY=`echo $http_proxy | sed -e 's/\/$//'` &&\
  export HTTPS_PROXY=`echo $https_proxy | sed -e 's/\/$//'`

RUN bazel clean &&\
    export TF_BUILD_MAVX=MAVX512 &&\
    ./configure  &&\
    mkdir /tmp/avx512 &&\
    bazel --output_base=/tmp/bazel build --repository_cache=/tmp/cache  --config=opt --config=mkl --copt=-O3 --copt=-mavx2 --jobs $(nproc) --copt=-march=skylake-avx512 --copt=-mfma  --incompatible_remove_native_http_archive=false   //tensorflow/tools/pip_package:build_pip_package &&\
    bazel-bin/tensorflow/tools/pip_package/build_pip_package /tensorflow_builds/avx512/

CMD 'bash'


