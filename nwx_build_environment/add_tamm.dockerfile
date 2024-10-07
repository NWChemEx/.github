FROM nwx_buildenv:latest

ARG VERSION=main

# Install tamm (add dependencies)
RUN cd /tmp \
    && git clone https://github.com/NWChemEx/TAMM.git \
    && cd TAMM \
    && git checkout ${VERSION} \
    && bash /scripts/tamm_command.sh \
    && rm -rf /tmp/TAMM