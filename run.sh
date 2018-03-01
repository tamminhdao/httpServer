#!/usr/bin/env bash

export LOG_FILE_TIME_STAMP=$(date "+%Y%m%d%H%M%S")

touch "server_$LOG_FILE_TIME_STAMP"
exec ./.build/debug/CobSpec  "$@"
