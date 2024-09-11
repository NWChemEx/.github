FROM nwx_buildenv:latest

ARG VERSION=3.6.0
ARG COMPILER=gcc-11

# Install catch2 ##
RUN cd /tmp \
    && git clone https://github.com/catchorg/Catch2.git \
    && cd Catch2 \
    && git checkout v${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DBUILD_TESTING=OFF \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/Catch2
