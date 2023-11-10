FROM nwx_buildenv:latest

ARG VERSION=0.4.2
ARG COMPILER=gcc-9

# Install libfort ##
RUN cd /tmp \
    && git clone https://github.com/seleznevae/libfort.git \
    && cd libfort \
    && git checkout v${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DBUILD_TESTING=OFF \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/libfort
