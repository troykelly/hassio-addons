ARG BUILD_FROM
FROM $BUILD_FROM

# architecture
ARG BUILD_ARCH

# setup base
ARG C2_VERSION

RUN apk add --no-cache openssl outils-md5 net-tools

# Copy data
COPY data/run.sh /

RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# Install unimus
WORKDIR /usr/src/app
ADD https://storage.googleapis.com/cloudc2/c2-${C2_VERSION}_community.zip /usr/src/app/c2.zip

RUN unzip c2.zip

WORKDIR /
CMD [ "/run.sh" ]
