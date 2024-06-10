FROM nwx_buildenv:latest

ARG VERSION=c9ac8eba1bbb237206f620d7464be7725d1809eb

# Install tamm (add dependencies)
RUN cd /tmp \
    && git clone https://github.com/NWChemEx/TAMM.git \
    && cd TAMM \
    && git checkout ${VERSION} \
    && bash /scripts/tamm_command.sh \
    && rm -rf /tmp/TAMM