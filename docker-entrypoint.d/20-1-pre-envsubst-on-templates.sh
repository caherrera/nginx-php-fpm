#!/bin/sh

set -e

echo_upstream_server() {
    local S=$1;
    local P=$2;
    shift;shift;
    echo "server $S:$P $*;";
}

prepare_auto_envsubst() {
    local NGINX_SERVER_FPM_REPLICAS="${NGINX_SERVER_FPM_REPLICAS:-1}"
    local template_dir="${NGINX_ENVSUBST_TEMPLATE_DIR:-/etc/nginx/templates}"
    local suffix="${NGINX_ENVSUBST_TEMPLATE_SUFFIX:-.template}"
    local upstream_fpm_template=${NGINX_ENVSUBST_TEMPLATE_UPSTREAM_FPM_FILE:-"${template_dir}/php-fpm-upstream.conf${suffix}"}
    local NGINX_SERVER_FPM_PORT="${NGINX_SERVER_FPM_PORT:-9000}"
    local NGINX_SERVER_FPM="${NGINX_SERVER_FPM:-"app"}"
    [ -d "$template_dir" ] || return 0
    if [ ! -w "$template_dir" ]; then
        echo >&3 "$ME: ERROR: $template_dir exists, but is not writable"
        return 0
    fi
    echo "$upstream_fpm_template"
    [ ! -f "$upstream_fpm_template" ] || exit 0
    {
        echo "upstream phpfpm {";
        echo "$NGINX_SERVER_FPM_UPSTREAM_ARGS" ;
        echo_upstream_server "$NGINX_SERVER_FPM" "$NGINX_SERVER_FPM_PORT" "$NGINX_SERVER_FPM_SERVER_ARGS"
        if [ "$NGINX_SERVER_FPM_REPLICAS" -gt 1 ]; then
        local REPLICAS=$(($NGINX_SERVER_FPM_REPLICAS - 1))
        for i in $(seq 1 "$REPLICAS");
        do
            local x=$(($i + 1))
            echo_upstream_server "${NGINX_SERVER_FPM}_${x}" "$NGINX_SERVER_FPM_PORT" "$NGINX_SERVER_FPM_SERVER_ARGS"
        done
        fi
        echo "}"
    } > "$upstream_fpm_template" 

}

prepare_auto_envsubst

exit 0