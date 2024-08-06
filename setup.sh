#!/bin/bash

#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null
then
    echo "Docker not found. Installing Docker..."
    sudo apt-get update
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    sudo usermod -aG docker $USER
    newgrp docker << END
    exec "$0" "$@"
END
fi

# Prompt for domain name and email address if not already set
if [ -z "$DOMAIN" ]; then
    read -p "Enter your domain name (e.g., example.com): " DOMAIN
fi

if [ -z "$EMAIL" ]; then
    read -p "Enter your email address for Certbot (e.g., user@example.com): " EMAIL
fi

# Copy template files to their respective locations
cp docker-compose.yml.template docker-compose.yml
cp nginx.conf.template nginx.conf

# Update nginx.conf and nginx.conf.template files
sed -i "s/your_domain/$DOMAIN/g" nginx.conf
sed -i "s/your_domain/$DOMAIN/g" nginx.conf.template

# Update docker-compose.yml file
sed -i "s/your_email@example.com/$EMAIL/g" docker-compose.yml
sed -i "s/your_domain/$DOMAIN/g" docker-compose.yml

# Update certbot entrypoint in docker-compose.yml
sed -i "s/your_domain/$DOMAIN/g" docker-compose.yml.template
sed -i "s/your_email@example.com/$EMAIL/g" docker-compose.yml.template

# Check if the certificate files exist
if [ ! -f /etc/letsencrypt/live/$DOMAIN/fullchain.pem ] || [ ! -f /etc/letsencrypt/live/$DOMAIN/privkey.pem ]; then
    echo "SSL certificate files not found. Attempting to generate certificates using Certbot..."
    echo "Using email: $EMAIL"
    echo "Using domain: $DOMAIN"
    sudo docker run --rm -v certbot-etc:/etc/letsencrypt -v certbot-var:/var/lib/letsencrypt -v certbot-log:/var/log/letsencrypt certbot/certbot certonly --webroot -w /var/www/certbot --email "$EMAIL" --agree-tos --no-eff-email -d "$DOMAIN"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to generate SSL certificates."
        exit 1
    fi
else
    echo "SSL certificate files found."
fi

echo "Configuration updated successfully."

# Start Docker Compose services
sudo docker compose up -d
