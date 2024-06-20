FROM nwx_buildenv:latest

ARG VERSION=16623d6722ae521edec0b36b460cc25161e42721

# Install tamm (add dependencies)
RUN cd /tmp \
    && git clone https://github.com/NWChemEx/TAMM.git \
    && cd TAMM \
    && git checkout ${VERSION} \
    && bash /scripts/tamm_command.sh \
    && rm -rf /tmp/TAMM