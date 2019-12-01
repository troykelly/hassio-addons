ARG BUILD_FROM
FROM $BUILD_FROM

# Install unimus + auth plugin
WORKDIR /usr/src/app
ADD https://unimus.net/download/-%20Latest/Unimus.jar /usr/src/app/Unimus.jar
RUN apk add --no-cache openjdk10 curl openssl musl socat pwgen

# Copy data
COPY data/run.sh /
COPY data/auth_srv.sh /bin/
COPY data/unimus.properties /etc/unimus/unimus.properties
COPY data/unimus.default /etc/default/unimus

WORKDIR /
CMD [ "/run.sh" ]
