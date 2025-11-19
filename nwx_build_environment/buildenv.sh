# Copyright 2025 NWChemEx-Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

docker build -t nwx_buildenv -f nwx_buildenv.dockerfile .

# Build dependencies with both GCC and Clang
deps=("cereal" "gauxc" "libfort" "spdlog" "libint")
for dep in "${deps[@]}"
do
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=gcc-14 .
    docker build -t nwx_buildenv -f add_${dep}.dockerfile --build-arg COMPILER=clang-19 .
    docker image prune -f
done

# TAMM, exachem are special cases for now
# docker build -t nwx_buildenv -f add_tamm.dockerfile .
# docker build -t nwx_buildenv -f add_exachem.dockerfile .
# docker image prune -f
