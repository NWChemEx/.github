FROM nwx_buildenv:latest

ARG VERSION=2.13.8
ARG COMPILER=gcc-9

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
