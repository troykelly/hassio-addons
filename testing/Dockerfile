ARG BUILD_FROM
FROM $BUILD_FROM

# architecture
ARG BUILD_ARCH

# setup base
ARG UNIMUS_VERSION

# Copy data
COPY data/run.sh /

WORKDIR /
CMD [ "/run.sh" ]
