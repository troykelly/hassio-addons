#!/usr/bin/env bashio

UNIMUS_DIR=/data/unimus

mkdir -p "$UNIMUS_DIR"

LICENSE_KEY=$(bashio::config 'license.key')
DATABASE_ENCRYPTION_KEY=$(bashio::config 'encryption.key')
DATABASE_HOST=$(bashio::config 'database.host')
DATABASE_PORT=$(bashio::config 'database.port')
DATABASE_NAME=$(bashio::config 'database.name')
DATABASE_USER=$(bashio::config 'database.user')
DATABASE_PASSWORD=$(bashio::config 'database.password')
LOGGING=$(bashio::config 'logging')

## Main ##

bashio::log.info "Setup Unimus configuration"
sed -E -i "s/^(#.*)*(license\.key) *= *(.*)$/\2 = $LICENSE_KEY/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.encryption\.key) *= *(.*)$/\2 = $DATABASE_ENCRYPTION_KEY/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.host) *= *(.*)$/\2 = $DATABASE_HOST/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.port) *= *(.*)$/\2 = $DATABASE_PORT/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.name) *= *(.*)$/\2 = $DATABASE_NAME/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.user) *= *(.*)$/\2 = $DATABASE_USER/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.password) *= *(.*)$/\2 = $DATABASE_PASSWORD/g" /etc/unimus/unimus.properties

# Start Unimus Server
java -jar /usr/src/app/Unimus.jar &
WAIT_PIDS+=($!)

# Handling Closing
function stop_unimus() {
    bashio::log.info "Shutdown Unimus system"
    kill -15 "${WAIT_PIDS[@]}"
    
    wait "${WAIT_PIDS[@]}"
}
trap "stop_unimus" SIGTERM SIGHUP

# Wait and hold Add-on running
wait "${WAIT_PIDS[@]}"
