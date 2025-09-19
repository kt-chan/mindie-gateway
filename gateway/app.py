from waitress import serve
from auth_service import app
import os

if __name__ == '__main__':
    host = os.environ.get('AUTH_SERVICE_HOST', '127.0.0.1')
    port = int(os.environ.get('AUTH_SERVICE_PORT', 8020))
    serve(app, host=host, port=port)