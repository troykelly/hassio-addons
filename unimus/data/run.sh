#!/usr/bin/env bashio
set +u

CONFIG_PATH=/data/options.json
SYSTEM_USER=/data/system_user.json

LICENSE_KEY=$(jq --raw-output ".license.key" $CONFIG_PATH)
DATABASE_ENCRYPTION_KEY=$(jq --raw-output ".encryption.key" $CONFIG_PATH)
DATABASE_HOST=$(jq --raw-output ".database.host" $CONFIG_PATH)
DATABASE_PORT=$(jq --raw-output ".database.port" $CONFIG_PATH)
DATABASE_NAME=$(jq --raw-output ".database.name" $CONFIG_PATH)
DATABASE_USER=$(jq --raw-output ".database.user" $CONFIG_PATH)
DATABASE_PASSWORD=$(jq --raw-output ".database.password" $CONFIG_PATH)
LOGGING=$(bashio::info 'hassio.info.logging' '.logging')

HOMEASSISTANT_PW=
ADDONS_PW=

function write_system_users() {
    (
        echo "{\"homeassistant\": {\"password\": \"$HOMEASSISTANT_PW\"}, \"addons\": {\"password\": \"$ADDONS_PW\"}}"
    ) > "${SYSTEM_USER}"
}

function call_hassio() {
    local method=$1
    local path=$2
    local data="${3}"
    local token=

    token="X-Hassio-Key: ${HASSIO_TOKEN}"
    url="http://hassio/${path}"

    # Call API
    if [ -n "${data}" ]; then
        curl -f -s -X "${method}" -d "${data}" -H "${token}" "${url}"
    else
        curl -f -s -X "${method}" -H "${token}" "${url}"
    fi

    return $?
}

function constrain_host_config() {
    local user=$1
    local password=$2

    echo "{"
    echo "  \"host\": \"$(hostname)\","
    echo "  \"port\": 1883,"
    echo "  \"ssl\": false,"
    echo "  \"protocol\": \"3.1.1\","
    echo "  \"username\": \"${user}\","
    echo "  \"password\": \"${password}\""
    echo "}"
}

function constrain_discovery() {
    local user=$1
    local password=$2
    local config=

    config="$(constrain_host_config "${user}" "${password}")"
    echo "{"
    echo "  \"service\": \"mqtt\","
    echo "  \"config\": ${config}"
    echo "}"
}

## Main ##

bashio::log.info "Setup Unimus configuration"
sed -E -i "s/^(#.*)*(license\.key) *= *(.*)$/\2 = $LICENSE_KEY/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.encryption\.key) *= *(.*)$/\2 = $DATABASE_ENCRYPTION_KEY/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.host) *= *(.*)$/\2 = $DATABASE_HOST/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.port) *= *(.*)$/\2 = $DATABASE_PORT/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.name) *= *(.*)$/\2 = $DATABASE_NAME/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.user) *= *(.*)$/\2 = $DATABASE_USER/g" /etc/unimus/unimus.properties
sed -E -i "s/^(#.*)*(database\.password) *= *(.*)$/\2 = $DATABASE_PASSWORD/g" /etc/unimus/unimus.properties

# Prepare System Accounts
if [ ! -e "${SYSTEM_USER}" ]; then
    HOMEASSISTANT_PW="$(pwgen 64 1)"
    ADDONS_PW="$(pwgen 64 1)"

    bashio::log.info "Initialize system configuration."
    write_system_users
else
    HOMEASSISTANT_PW=$(jq --raw-output '.homeassistant.password' $SYSTEM_USER)
    ADDONS_PW=$(jq --raw-output '.addons.password' $SYSTEM_USER)
fi

# Initial Service
if call_hassio GET "services/unimus" | jq --raw-output ".data.host" | grep -v "$(hostname)" > /dev/null; then
    bashio::log.warning "There is already a Unimus service running!"
else
    bashio::log.info "Initialize Hass.io Add-on services"
    if ! call_hassio POST "services/unimus" "$(constrain_host_config addons "${ADDONS_PW}")" > /dev/null; then
        bashio::log.error "Can't setup Hass.io service unimus"
    fi

    bashio::log.info "Initialize Home Assistant discovery"
    if ! call_hassio POST "discovery" "$(constrain_discovery homeassistant "${HOMEASSISTANT_PW}")" > /dev/null; then
        bashio::log.error "Can't setup Home Assistant discovery unimus"
    fi
fi

bashio::log.info "Start Unimus daemon"

# Start Auth Server
socat TCP-LISTEN:8080,fork,reuseaddr SYSTEM:/bin/auth_srv.sh &
WAIT_PIDS+=($!)

# Start Mosquitto Server
java -jar /usr/src/app/Unimus.jar &
WAIT_PIDS+=($!)

# Handling Closing
function stop_unimus() {
    bashio::log.info "Shutdown Unimus system"
    kill -15 "${WAIT_PIDS[@]}"

    # Remove service
    if call_hassio GET "services/unimus" | jq --raw-output ".data.host" | grep "$(hostname)" > /dev/null; then
        if ! call_hassio DELETE "services/unimus"; then
            bashio::log.warning "Service unregister fails!"
        fi
    fi

    wait "${WAIT_PIDS[@]}"
}
trap "stop_unimus" SIGTERM SIGHUP

# Wait and hold Add-on running
wait "${WAIT_PIDS[@]}"
