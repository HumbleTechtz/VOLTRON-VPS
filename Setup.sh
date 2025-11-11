bash
#!/bin/bash
# 🚀 VOLTRON BOY SERVER - MAIN SETUP SCRIPT
# GitHub: https://github.com/yourusername/voltronserver

echo "╔═══════════════════════════════════════╗"
echo "║          VOLTRON BOY SERVER          ║"
echo "║           Setup Script v1.0          ║"
echo "║         GitHub: voltronserver        ║"
echo "╚═══════════════════════════════════════╝"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print status
print_status() { echo -e "${GREEN}[✓]${NC} $1"; }
print_error() { echo -e "${RED}[✗]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[!]${NC} $1"; }
print_info() { echo -e "${BLUE}[i]${NC} $1"; }

# Check root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run as root: sudo ./setup.sh"
    exit 1
fi

# Welcome message
print_info "Voltron Boy Server Setup"
print_info "Support: http://wa.me/255738132447"
echo

# 📝 STEP 1: ADMIN CREDENTIALS
echo "┌─────────────────────────────────────┐"
echo "│   WEB PANEL ADMIN SETUP             │"
echo "├─────────────────────────────────────┤"
read -p "│ Admin Username: " admin_username
read -s -p "│ Admin Password: " admin_password
echo
read -s -p "│ Confirm Password: " admin_password_confirm
echo
echo "└─────────────────────────────────────┘"

if [ "$admin_password" != "$admin_password_confirm" ]; then
    print_error "Passwords do not match!"
    exit 1
fi

# 📝 STEP 2: DOMAIN SETUP
echo
echo "┌─────────────────────────────────────┐"
echo "│         DOMAIN CONFIGURATION        │"
echo "├─────────────────────────────────────┤"
read -p "│ Domain Name: " domain_name
read -p "│ VPS IP Address: " vps_ip
echo "└─────────────────────────────────────┘"

print_status "Starting installation..."

# 📦 STEP 3: SYSTEM UPDATE
print_status "Updating system packages..."
apt update && apt upgrade -y

# 📦 STEP 4: INSTALL DEPENDENCIES
print_status "Installing dependencies..."
apt install -y curl wget git build-essential nginx python3 python3-pip nodejs npm golang

# 📁 STEP 5: CREATE DIRECTORY STRUCTURE
print_status "Creating directory structure..."
mkdir -p /opt/voltronserver/{scripts,web_panel,configs,logs,users,backups}
cd /opt/voltronserver

# 💾 STEP 6: SAVE CONFIGURATION
print_status "Saving configuration..."
cat > /opt/voltronserver/configs/server.conf << EOF
# Voltron Boy Server Configuration
DOMAIN="$domain_name"
VPS_IP="$vps_ip"
ADMIN_USER="$admin_username"
ADMIN_PASSWORD="$admin_password"
INSTALL_DIR="/opt/voltronserver"
WEB_PORT="8080"
SSH_PORT="22"
DNSTT_PORT="53"
EOF

# 🔧 STEP 7: RUN SERVICE SCRIPTS
print_status "Installing DNSTT Server..."
./scripts/install_dnstt.sh

print_status "Configuring SSH Services..."
./scripts/install_ssh.sh

print_status "Setting up Web Panel..."
./scripts/setup_web_panel.sh

# ✅ STEP 8: FINAL SETUP
print_status "Finalizing setup..."

# Create admin user
useradd -m -s /bin/bash $admin_username 2>/dev/null
echo "$admin_username:$admin_password" | chpasswd

# Start services
systemctl daemon-reload
systemctl enable nginx
systemctl start nginx

# 🎉 COMPLETION MESSAGE
echo
echo "╔═══════════════════════════════════════╗"
echo "║          SETUP COMPLETE!             ║"
echo "╠═══════════════════════════════════════╣"
echo "║ 🌐 Web Panel: https://$domain_name:8080 ║"
echo "║ 👤 Admin: $admin_username                ║"
echo "║ 🔑 Password: ********                ║"
echo "║ 📞 Support: http://wa.me/255738132447║"
echo "║ 🐙 GitHub: voltronserver             ║"
echo "╚═══════════════════════════════════════╝"

print_status "Installation completed successfully!"
print_warning "Don't forget to setup DNS records!"
print_info "Next: Login to web panel and create user accounts"

# Save setup log
echo "Setup completed: $(date)" >> /opt/voltronserver/logs/setup.log
