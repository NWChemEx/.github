FROM nwx_buildenv:latest

ARG VERSION=3d585293f0094588778dbd3bec24b65e7bbe6a5d
ARG COMPILER=gcc-9

# Install MADNESS
RUN cd /tmp \
    && git clone https://github.com/m-a-d-n-e-s-s/madness.git \
    && cd madness \
    && git checkout ${VERSION}\
    && cmake -Bbuild -H. -GNinja \
    -DENABLE_UNITTESTS=OFF \ 
    -DMADNESS_BUILD_MADWORLD_ONLY=ON \
    -DMADNESS_ENABLE_CEREAL=ON \
    -DENABLE_MKL=OFF \
    -DENABLE_ACML=OFF \
    -DBUILD_TESTING=OFF \
    -DCMAKE_PREFIX_PATH=/nwx_dependencies/${COMPILER} \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/madness
