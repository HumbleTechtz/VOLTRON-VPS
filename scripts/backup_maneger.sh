#!/bin/bash
# 💾 VOLTRON SERVER BACKUP MANAGER

BACKUP_DIR="/opt/voltronserver/backups"
CONFIG_DIR="/opt/voltronserver/configs"
LOG_DIR="/opt/voltronserver/logs"

backup_server() {
    local backup_name="voltronserver_backup_$(date +%Y%m%d_%H%M%S)"
    local backup_path="$BACKUP_DIR/$backup_name.tar.gz"
    
    echo "💾 Creating backup: $backup_name"
    
    # Create backup
    tar -czf $backup_path $CONFIG_DIR $LOG_DIR 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ Backup created: $backup_path"
        echo "📦 Size: $(du -h $backup_path | cut -f1)"
    else
        echo "❌ Backup failed!"
        return 1
    fi
}

restore_backup() {
    local backup_file=$1
    
    if [ ! -f "$backup_file" ]; then
        echo "❌ Backup file not found: $backup_file"
        return 1
    fi
    
    echo "🔄 Restoring from backup: $backup_file"
    
    # Stop services
    systemctl stop nginx
    systemctl stop dnstt
    
    # Restore files
    tar -xzf $backup_file -C /
    
    # Start services
    systemctl start nginx
    systemctl start dnstt
    
    echo "✅ Backup restored successfully"
}

list_backups() {
    echo "📦 Available Backups:"
    ls -la $BACKUP_DIR/*.tar.gz 2>/dev/null || echo "No backups found"
}

case "$1" in
    create)
        backup_server
        ;;
    restore)
        restore_backup "$2"
        ;;
    list)
        list_backups
        ;;
    *)
        echo "Usage: $0 {create|restore [file]|list}"
        exit 1
        ;;
esac
