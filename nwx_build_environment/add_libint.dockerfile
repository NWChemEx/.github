FROM nwx_buildenv:latest

ARG VERSION=2.9.0
ARG COMPILER=gcc-11

# Install libfort ##
RUN cd /tmp \
    && wget https://github.com/evaleev/libint/releases/download/v${VERSION}/libint-${VERSION}.tgz \
    && tar -zxf libint-${VERSION}.tgz \
    && cd libint-${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install --parallel \
    && rm -rf /tmp/libint-${VERSION}
