FROM nwx_buildenv:latest

ARG VERSION=master
ARG COMPILER=gcc-9

# Install libfort ##
RUN cd /tmp \
    && git clone https://github.com/wavefunction91/GauXC.git \
    && cd GauXC \
    && git checkout ${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DGAUXC_ENABLE_HDF5=OFF \
    -DBUILD_TESTING=OFF \
    -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install --parallel \
    && rm -rf /tmp/GauXC
