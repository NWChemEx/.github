FROM nwx_buildenv:latest

ARG VERSION=63e180bf55849c173585a734c5e7456cbf31a986
ARG COMPILER=gcc-9

# Install TiledArray
RUN cd /tmp \
    && git clone https://github.com/ValeevGroup/TiledArray.git tiledarray \
    && cd tiledarray \
    && git checkout ${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DTA_BUILD_UNITTEST=OFF \
    -DBUILD_TESTING=OFF \
    -DBLAS_THREAD_LAYER=sequential \
    -DCMAKE_PREFIX_PATH=/nwx_dependencies/${COMPILER} \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && cd .. \
    && rm -rf tiledarray
