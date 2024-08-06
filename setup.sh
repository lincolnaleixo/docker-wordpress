#!/bin/bash

#!/bin/bash

# Prompt for domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN

# Prompt for email address
read -p "Enter your email address for Certbot (e.g., user@example.com): " EMAIL

# Copy template files to their respective locations
cp nginx.conf.template nginx.conf

# Update nginx.conf file
sed -i '' "s/your_domain/$DOMAIN/g" nginx.conf

# Update docker-compose.yml file
sed -i '' "s/your_email@example.com/$EMAIL/g" docker-compose.yml
sed -i '' "s/your_domain/$DOMAIN/g" docker-compose.yml

echo "Configuration updated successfully."
