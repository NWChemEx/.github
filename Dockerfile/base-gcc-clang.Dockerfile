ARG UBUNTU_VERSION

FROM ubuntu:${UBUNTU_VERSION}

ARG GCC_VERSION
ARG CLANG_VERSION

# Install gcc, clang and basic tools
RUN    apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
                git \
                wget \
                pip \
                gcc-${GCC_VERSION} \
                g++-${GCC_VERSION} \
                clang-${CLANG_VERSION} \
                libc++-${CLANG_VERSION}-dev \
                libc++abi-${CLANG_VERSION}-dev \
                ninja-build \
                libxml2-dev \
                libxslt-dev \
                python3-dev \
                docker.io \
        && apt-get clean \
        && pip install gcovr \
        && pip install cppyy \
        && rm -rf /var/lib/apt/lists/*

LABEL maintainer="NWChemEx-Project" \
      description="Basic building image." \
      ubuntu_version=${UBUNTU_VERSION} \
      gcc_version=${GCC_VERSION} \
      clang_version=${CLANG_VERSION} 
