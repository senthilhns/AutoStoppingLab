#!/bin/bash

# Update & install nginx and openssl
sudo apt-get update -y
sudo apt-get install -y nginx openssl

# Create self-signed SSL certificate
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /etc/ssl/private/nginx-selfsigned.key \
  -out /etc/ssl/certs/nginx-selfsigned.crt \
  -subj "/CN=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"

# Write nginx config with HTTP 200 message and HTTPS static file
sudo tee /etc/nginx/conf.d/default.conf > /dev/null <<'EOF'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;

    location / {
        return 200 'Hello from Nginx over HTTP port 80';
        add_header Content-Type text/plain;
    }
}

server {
    listen 443 ssl default_server;
    listen [::]:443 ssl default_server;
    server_name _;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

    location / {
        return 200 'Hello from Nginx over HTTPS port 443';
        add_header Content-Type text/plain;
    }
}
EOF

# Create HTTPS content
echo "Hello from Nginx over HTTPS port 443" | sudo tee /var/www/html/index.html
sudo chown www-data:www-data /var/www/html/index.html

# Remove default site
rm /etc/nginx/sites-enabled/default

# Test and reload nginx
sudo nginx -t && sudo systemctl reload nginx

# Done
echo "✅ Nginx is configured to serve HTTP and HTTPS with custom messages"
