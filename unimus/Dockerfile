ARG BUILD_FROM
FROM $BUILD_FROM

# architecture
ARG BUILD_ARCH

# setup base
ARG UNIMUS_VERSION

# Install unimus
WORKDIR /usr/src/app
RUN apk add --no-cache openjdk8 openssl outils-md5
ADD https://unimus.net/download/${UNIMUS_VERSION}/Unimus.jar /usr/src/app/Unimus.jar

# Copy data
COPY data/run.sh /
COPY data/unimus.properties /etc/unimus/unimus.properties
COPY data/unimus.default /etc/default/unimus

WORKDIR /
CMD [ "/run.sh" ]
