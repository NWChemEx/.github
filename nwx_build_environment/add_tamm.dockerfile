FROM nwx_buildenv:latest

ARG VERSION=7c6657610640c5d0f0aa2128da0eef4873f72738

# Install tamm (add dependencies)
RUN cd /tmp \
    && git clone https://github.com/NWChemEx/TAMM.git \
    && cd TAMM \
    && git checkout ${VERSION} \
    && bash /scripts/tamm_command.sh \
    && rm -rf /tmp/TAMM