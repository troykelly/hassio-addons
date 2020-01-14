#!/usr/bin/env bashio

LICENSE_KEY=$(bashio::config 'license.key')
LOGGING=$(bashio::config 'logging')
SSLCERTFILE=$(bashio::config 'certfile')
SSLKEYFILE=$(bashio::config 'keyfile')
C2HOSTNAME=$(bashio::config 'hostname')
HOST_ARCH=$(bashio::homeassistant.arch)
C2DB="/data/c2"

mkdir -p "${C2DB}"

C2_ARCH="linux-64"
if [ "$HOST_ARCH" == "i386" ]; then
  C2_ARCH="linux-32"
fi
if [ "$HOST_ARCH" == "armv7" ]; then
  C2_ARCH="linux-armv7"
fi
if [ "$HOST_ARCH" == "armhf" ]; then
  C2_ARCH="linux-armv7"
fi

## Main ##
if bashio::config.true 'ssl'; then
  SSLPASSWORD=$(date | md5)
  bashio::log.info "Starting Hak5 C2 with SSL on ${C2HOSTNAME}"
  /usr/src/app/c2_community-${C2_ARCH} -db "${C2DB}"/c2.db -certFile /ssl/"$SSLCERTFILE" -keyFile /ssl/"$SSLKEYFILE" -https -hostname "${C2HOSTNAME}" -reverseProxy -reverseProxyPort 443 -listenport 8686 &
  WAIT_PIDS+=($!)
else
  bashio::log.info "Starting Hak5 C2 on ${C2HOSTNAME}"
  /usr/src/app/c2_community-${C2_ARCH} -db "${C2DB}"/c2.db -hostname "${C2HOSTNAME}" -reverseProxy -reverseProxyPort 80 -listenport 8686 &
  WAIT_PIDS+=($!)
fi

# Handling Closing
function stop_hak5c2() {
    bashio::log.info "Shutdown Hak5 C2 system"
    kill -15 "${WAIT_PIDS[@]}"

    wait "${WAIT_PIDS[@]}"
}
trap "stop_hak5c2" SIGTERM SIGHUP

bashio::log.info "C2 ready on ${C2HOSTNAME}"

# Wait and hold Add-on running
wait "${WAIT_PIDS[@]}"
