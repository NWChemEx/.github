FROM nwx_buildenv:latest

ARG VERSION=ad0e89cbfb4d0c1ce4d097e134eb7be67baebb36
ARG COMPILER=gcc-9

# Install spdlog
RUN cd /tmp \
    && git clone https://github.com/gabime/spdlog.git \
    && cd spdlog \
    && git checkout ${VERSION} \
    && cmake -Bbuild -H. -GNinja \
    -DSPDLOG_INSTALL=ON \
    -DCMAKE_CXX_FLAGS="-fPIC" \
    -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/${COMPILER} \
    -DCMAKE_TOOLCHAIN_FILE=/toolchains/${COMPILER}.cmake \
    && cmake --build build --target install \
    && rm -rf /tmp/spdlog
