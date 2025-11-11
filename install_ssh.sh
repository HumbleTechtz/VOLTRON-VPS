#!/bin/bash
# 🔐 SSH SERVICES INSTALLATION SCRIPT

print_status() { echo -e "\033[0;32m[✓]\033[0m $1"; }

print_status "Configuring SSH Services..."

# Install SSH server
apt install -y openssh-server

# Configure SSH
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/g' /etc/ssh/sshd_config

# Restart SSH
systemctl restart ssh
systemctl enable ssh

print_status "SSH Services configured successfully"
