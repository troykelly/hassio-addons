ARG BUILD_FROM
FROM $BUILD_FROM

# architecture
ARG BUILD_ARCH

# setup base
ARG UNIMUS_VERSION

# Copy data
COPY data/run.sh /
COPY data/unimus.properties /etc/unimus/unimus.properties

RUN apk add --no-cache openjdk8 openssl outils-md5

# Install unimus
WORKDIR /usr/src/app
ADD https://unimus.net/download/${UNIMUS_VERSION}/Unimus.jar /usr/src/app/Unimus.jar

WORKDIR /
CMD [ "/run.sh" ]
