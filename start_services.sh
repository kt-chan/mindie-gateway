#!/bin/sh
set -e

# Start Python auth service in background
python3 /app/auth_service.py &

# Start NGINX in foreground
exec nginx -g "daemon off;"
