FROM nginx:alpine

WORKDIR /usr/share/nginx/html

# Install git, openssl
RUN apk add --no-cache git openssl

# Clean default files and clone VDO.Ninja
RUN rm -rf ./* && \
    git clone https://github.com/steveseguin/vdo.ninja.git && \
    cp -r vdo.ninja/* . && \
    cp -r vdo.ninja/.* . 2>/dev/null || true && \
    rm -rf vdo.ninja

# Create folder for SSL certs
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed certificate
RUN openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/CN=localhost"

# Replace default nginx config
COPY nginx.conf /etc/nginx/nginx.conf
