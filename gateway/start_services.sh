#!/bin/sh
set -e

export PYTHONPATH="${PYTHONPATH}:/app"

# Start Waitress in background with log redirection
waitress-serve --host=0.0.0.0 --port=8020 "auth_service:app" > /proc/1/fd/1 2>/proc/1/fd/2 &
WAITRESS_PID=$!

# Start NGINX in background with log redirection
nginx -g "daemon off;" > /proc/1/fd/1 2>/proc/1/fd/2 &
NGINX_PID=$!

# Trap signals to gracefully shutdown
trap 'kill $WAITRESS_PID $NGINX_PID' TERM INT

# Wait for either service to exit
while true; do
  # Check if Waitress is still running
  kill -0 $WAITRESS_PID 2>/dev/null
  WAITRESS_STATUS=$?
  
  # Check if NGINX is still running
  kill -0 $NGINX_PID 2>/dev/null
  NGINX_STATUS=$?

  # If either service died, kill the other and exit
  if [ $WAITRESS_STATUS -ne 0 ] || [ $NGINX_STATUS -ne 0 ]; then
    echo "Service died, stopping container"
    kill $WAITRESS_PID $NGINX_PID 2>/dev/null
    exit 1
  fi
  
  sleep 1
done
