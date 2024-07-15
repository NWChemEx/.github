FROM nwx_buildenv:latest

ARG VERSION=2024-07-15

# Install exachem (add dependencies)
RUN cd /tmp \
    && git clone https://github.com/ExaChem/exachem.git \
    && cd exachem \
    && git checkout ${VERSION} \
    && bash /scripts/tamm_command.sh \
    && rm -rf /tmp/exachem