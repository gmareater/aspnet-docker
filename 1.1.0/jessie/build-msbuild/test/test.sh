#!/usr/bin/env bash

set -e

# colors
GRAY="\033[0;90m"
RED="\033[0;31m"
CYAN="\033[1;36m"
GREEN="\033[0;32m"
NC="\033[0m"

# utility functions
log() {
    printf "${GRAY}log: $@${NC}\n"
}

fatal() {
    printf "${RED}error: $@${NC}\n"
    exit 1
}

# tests
test_restore() {
    mkdir -p /tmp/SimpleWebServer
    cp -R /test/SimpleWebServer/ /tmp/
    cd /tmp/SimpleWebServer/
    dotnet restore --source /root/.nuget/packages
}

test_build() {
    cd /tmp/SimpleWebServer/
    dotnet build /nologo /v:m
}

test_run() {
    cd /tmp/SimpleWebServer/
    dotnet run &
    local pid=$!
    log "dotnet run PID = $pid"
    local retry=10
    local url='127.0.0.1:80'
    until curl -s -o /dev/null $url; do
        retry=$((retry - 1))
        if [ $retry -le 0 ]; then
            kill $pid
            fatal 'Exceeded maximum attempts to connect to local web server'
        fi
        log "$(date) - waiting for connection to $url..."
        sleep 1
    done
    log "Connection to $url succeeded"
    kill $pid || true
}

# main
for t in test_restore test_build test_run; do
    log "${CYAN}Starting $t"
    $t
    log "${GREEN}$t passed\n\n"
done