docker build -t nwx_buildenv -f nwx_buildenv.dockerfile .

deps=("cereal" "madness" "tiledarray" "gauxc" "libfort" "catch2" "spdlog")
for dep in "${deps[@]}"
do
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=gcc-9 .
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=gcc-11 .
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=clang-11 .
    docker image prune -f
done