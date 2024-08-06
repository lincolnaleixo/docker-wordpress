#!/bin/bash

#!/bin/bash

# Prompt for domain name
read -p "Enter your domain name (e.g., example.com): " DOMAIN

# Copy template files to their respective locations
cp nginx.conf.template nginx.conf

# Update nginx.conf file
sed -i '' "s/your_domain/$DOMAIN/g" nginx.conf

echo "Configuration updated successfully."
