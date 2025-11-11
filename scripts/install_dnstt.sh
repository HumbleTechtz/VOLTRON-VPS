#!/bin/bash
# 📦 DNSTT SERVER INSTALLATION SCRIPT

print_status() { echo -e "\033[0;32m[✓]\033[0m $1"; }

print_status "Installing DNSTT Server..."

# Install DNSTT
cd /opt/voltronserver
git clone https://www.bamsoftware.com/git/dnstt.git
cd dnstt/dnstt-server
go build
cd ../..
cp dnstt/dnstt-server/dnstt-server /usr/local/bin/

# Generate keys
/usr/local/bin/dnstt-server -gen-key /opt/voltronserver/configs/dnstt.key
/usr/local/bin/dnstt-server -gen-key /opt/voltronserver/configs/dnstt.pub

# Create service
cat > /etc/systemd/system/dnstt.service << EOF
[Unit]
Description=DNSTT Server
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/dnstt-server -udp :53 -pubkey-file /opt/voltronserver/configs/dnstt.pub
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable dnstt
systemctl start dnstt

print_status "DNSTT Server installed successfully"
