FROM nwx_buildenv:latest

ARG VERSION=1.3.0
ARG COMPILER=gcc-9

# Install cereal
RUN cd /tmp \
    && git clone https://github.com/USCiLab/cereal.git \
    && cd cereal \
    && git checkout v${VERSION} \
    && cmake -Bbuild -H. -GNinja\
    -DJUST_INSTALL_CEREAL=ON \
    -DBUILD_TESTS=OFF \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/cereal
