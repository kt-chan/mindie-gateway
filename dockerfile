FROM python:3-alpine

# Then proceed with your customizations
RUN pip install --no-cache-dir flask 
#
# Install NGINX first
RUN apk add --no-cache nginx

# Create directory structure
RUN mkdir -p /etc/nginx/auth /var/log/nginx /app

# Copy NGINX configuration
COPY nginx.conf /etc/nginx/nginx.conf
COPY api_keys.txt /etc/nginx/api_keys.txt

# Copy Python auth service
COPY auth_service.py /app/auth_service.py

# Copy wrapper script
COPY start_services.sh /app/start_services.sh
RUN chmod +x /app/start_services.sh

# Set environment variables with defaults
ENV AUTH_SERVICE_HOST=127.0.0.1
ENV AUTH_SERVICE_PORT=8020
ENV OPENAI_API_KEYS=""

# Expose ports
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Use wrapper script to start both services
CMD ["/app/start_services.sh"]
