CC=gcc CXX=g++ FC=gfortran cmake -Bbuild -H. -DCMAKE_INSTALL_PREFIX=/nwx_dependencies/gcc-11 -DCMAKE_BUILD_TYPE=Release -DBLAS_INT4=ON -DMODULES="DFT" -DCMAKE_TOOLCHAIN_FILE=/toolchains/tamm.cmake -DUSE_LIBNUMA=OFF -DCMSB_TAG=2024-07-15
cd build
make -j2
make install
