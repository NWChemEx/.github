docker build -t nwx_buildenv -f nwx_buildenv.dockerfile .

# Build dependencies with both GCC and Clang
deps=("cereal" "gauxc" "libfort" "catch2" "spdlog")
for dep in "${deps[@]}"
do
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=gcc-11 .
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=clang-14 .
    docker image prune -f
done

# TAMM, exachem are special cases for now
docker build -t nwx_buildenv -f add_tamm.dockerfile .
docker build -t nwx_buildenv -f add_exachem.dockerfile .
docker image prune -f
