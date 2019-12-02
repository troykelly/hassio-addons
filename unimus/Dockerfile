ARG BUILD_FROM
FROM $BUILD_FROM

# architecture
ARG BUILD_ARCH

# setup base
ARG UNIMUS_VERSION

# Install unimus
WORKDIR /usr/src/app
RUN if [ "${BUILD_ARCH}" = "amd64" ] ; then apk add --no-cache openjdk10 ; fi
RUN if [ "${BUILD_ARCH}" = "aarch64" ] ; then apk add --no-cache openjdk10 ; fi
RUN if [ "${BUILD_ARCH}" = "i386" ] ; then apk add --no-cache openjdk8 ; fi
RUN if [ "${BUILD_ARCH}" = "armhf" ] ; then apk add --no-cache openjdk8 ; fi
RUN if [ "${BUILD_ARCH}" = "armv7" ] ; then apk add --no-cache openjdk8 ; fi
ADD https://unimus.net/download/${UNIMUS_VERSION}/Unimus.jar /usr/src/app/Unimus.jar

# Copy data
COPY data/run.sh /
COPY data/unimus.properties /etc/unimus/unimus.properties
COPY data/unimus.default /etc/default/unimus

WORKDIR /
CMD [ "/run.sh" ]
