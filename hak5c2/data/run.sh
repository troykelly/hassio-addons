#!/usr/bin/env bashio

LICENSE_KEY=$(bashio::config 'license.key')
LOGGING=$(bashio::config 'logging')
SSLCERTFILE=$(bashio::config 'certfile')
SSLKEYFILE=$(bashio::config 'keyfile')
C2HOSTNAME=$(bashio::config 'hostname')

## Main ##
if bashio::config.true 'ssl'; then
  SSLPASSWORD=$(date | md5)
  bashio::log.info "Starting Hak5 C2 with SSL on ${C2HOSTNAME}"
  openssl pkcs12 -export -out /usr/src/app/cert.p12 -in /ssl/"$SSLCERTFILE" -inkey /ssl/"$SSLKEYFILE" -name unimus -passout pass:"$SSLPASSWORD"
  openssl pkcs12 -in /usr/src/app/cert.p12 -out /usr/src/app/cert.pem -clcerts -nokeys -passin pass:"$SSLPASSWORD"
  cat /usr/src/app/cert.pem
  /usr/src/app/c2_community-linux-64 -https -certFile /ssl/"$SSLCERTFILE" -keyFile /ssl/"$SSLKEYFILE" -hostname "${C2HOSTNAME}" -reverseProxy -reverseProxyPort 443 -listenport 8686
  WAIT_PIDS+=($!)
else
  bashio::log.info "Starting Hak5 C2 on ${C2HOSTNAME}"
  /usr/src/app/c2_community-linux-64 -hostname "${C2HOSTNAME}" -reverseProxy -reverseProxyPort 80 -listenport 8686
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
