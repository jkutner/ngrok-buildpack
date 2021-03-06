#!/usr/bin/env bash

if [ -n "$NGROK_TOKEN" ]; then
  local config
  if [ ! -f .ngrok2/ngrok.yml ]; then
    mkdir -p .ngrok2
    cat <<TOML > .ngrok2/ngrok.yml
tunnels:
  web:
    proto: http
    addr: ${PORT:-8080}
TOML
  fi

  ngrok_cmd="ngrok start --config .ngrok2/ngrok.yml -authtoken $NGROK_TOKEN -log stdout --log-level debug ${NGROK_OPTS:---all}"
  echo "[$(log_date)] INFO  Starting ngrok on port ${mc_port}..."
  eval "$ngrok_cmd | tee ngrok.log &"
  ngrok_pid=$!

  trap "kill ${ngrok_pid:-}" SIGTERM
  trap "kill -9 ${ngrok_pid:-}" SIGKILL
else
  echo 'at=ngrok level=warn status=failed message="NGROK_TOKEN not found"'
fi
