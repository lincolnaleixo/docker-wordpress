#!/bin/bash

# Prompt for domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN

# Update .env file
sed -i '' "s/your_domain/$DOMAIN/g" .env

# Update nginx.conf file
sed -i '' "s/your_domain/$DOMAIN/g" nginx.conf

echo "Configuration updated successfully."
