ARG BUILD_FROM
FROM $BUILD_FROM

ARG DAHUA_BRANCH="master"

RUN apk add --no-cache --update argon2-libs php php-json && \
apk add --no-cache --virtual .build-dependencies git

RUN git clone https://github.com/elad-bar/DahuaVTO2MQTT.git --branch ${DAHUA_BRANCH} --depth 1 /app && \
mv /app/DahuaEventHandler.php /app/DahuaVTO.php && \
chmod +x /app/DahuaVTO.php && \
apk del .build-dependencies

WORKDIR /app
COPY data/run.sh .
CMD ./run.sh