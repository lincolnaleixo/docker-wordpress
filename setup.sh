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
    newgrp docker
fi

# Prompt for domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN

# Prompt for email address
read -p "Enter your email address for Certbot (e.g., user@example.com): " EMAIL

# Copy template files to their respective locations
cp docker-compose.yml.template docker-compose.yml
cp nginx.conf.template nginx.conf

# Update nginx.conf file
sed -i '' "s/your_domain/$DOMAIN/g" nginx.conf

# Update docker-compose.yml file
sed -i '' "s/your_email@example.com/$EMAIL/g" docker-compose.yml
sed -i '' "s/your_domain/$DOMAIN/g" docker-compose.yml

echo "Configuration updated successfully."

# Start Docker Compose services
docker-compose up -d
