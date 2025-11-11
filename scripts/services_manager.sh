#!/bin/bash
# 🔧 VOLTRON SERVER SERVICE MANAGER

CONFIG_FILE="/opt/voltronserver/configs/services.conf"

# Load configuration
source $CONFIG_FILE

start_services() {
    echo "🚀 Starting Voltron Server Services..."
    
    systemctl start nginx
    systemctl start dnstt
    systemctl start ssh
    systemctl start v2ray
    
    echo "✅ All services started"
}

stop_services() {
    echo "🛑 Stopping Voltron Server Services..."
    
    systemctl stop nginx
    systemctl stop dnstt
    systemctl stop v2ray
    
    echo "✅ All services stopped"
}

restart_services() {
    echo "🔄 Restarting Voltron Server Services..."
    stop_services
    sleep 2
    start_services
}

status_services() {
    echo "📊 Voltron Server Status:"
    
    echo "🌐 Nginx: $(systemctl is-active nginx)"
    echo "🛰️ DNSTT: $(systemctl is-active dnstt)"
    echo "🔐 SSH: $(systemctl is-active ssh)"
    echo "🛡️ V2Ray: $(systemctl is-active v2ray)"
    
    echo "📞 Support: $SUPPORT_WHATSAPP"
}

case "$1" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    status)
        status_services
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac
