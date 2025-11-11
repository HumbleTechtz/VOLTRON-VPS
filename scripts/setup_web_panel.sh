#!/bin/bash
# 🌐 WEB PANEL SETUP SCRIPT

print_status() { echo -e "\033[0;32m[✓]\033[0m $1"; }

print_status "Setting up Web Panel..."

# Create web directory
mkdir -p /var/www/voltronserver
cp -r /opt/voltronserver/web_panel/* /var/www/voltronserver/

# Set permissions
chown -R www-data:www-data /var/www/voltronserver
chmod -R 755 /var/www/voltronserver

print_status "Web Panel setup completed"
