// 🚀 VOLTRON BOY SERVER - MAIN JAVASCRIPT
// Web Panel Functionality

// Configuration
const CONFIG = {
    API_BASE: '/api/',
    SUPPORT_URL: 'http://wa.me/255738132447',
    VERSION: '1.0.0'
};

// DOM Elements
let elements = {};

// Initialize when page loads
document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
    loadServerStatus();
    loadUserStats();
});

// Initialize application
function initializeApp() {
    console.log('🚀 Voltron Boy Server Admin Panel v' + CONFIG.VERSION);
    
    // Cache DOM elements
    elements = {
        userCount: document.getElementById('userCount'),
        serviceCount: document.getElementById('serviceCount'),
        serverStatus: document.querySelector('.server-status')
    };
    
    // Setup event listeners
    setupEventListeners();
    
    // Start auto-refresh
    startAutoRefresh();
}

// Setup event listeners
function setupEventListeners() {
    // Service control buttons
    document.querySelectorAll('.service-btn').forEach(btn => {
        btn.addEventListener('click', handleServiceControl);
    });
    
    // User creation buttons
    document.querySelectorAll('.user-create-btn').forEach(btn => {
        btn.addEventListener('click', handleUserCreation);
    });
    
    // Backup buttons
    document.querySelectorAll('.backup-btn').forEach(btn => {
        btn.addEventListener('click', handleBackup);
    });
}

// Load server status
async function loadServerStatus() {
    try {
        showLoading('status');
        
        // Simulate API call (replace with real API)
        const status = await simulateApiCall('status');
        
        updateStatusDisplay(status);
        showNotification('Server status updated', 'success');
        
    } catch (error) {
        console.error('Error loading status:', error);
        showNotification('Failed to load server status', 'error');
    }
}

// Load user statistics
async function loadUserStats() {
    try {
        showLoading('users');
        
        // Simulate API call
        const stats = await simulateApiCall('stats');
        
        updateUserStats(stats);
        
    } catch (error) {
        console.error('Error loading user stats:', error);
    }
}

// Update status display
function updateStatusDisplay(status) {
    if (elements.userCount) {
        elements.userCount.textContent = status.totalUsers || '0';
    }
    
    if (elements.serviceCount) {
        elements.serviceCount.textContent = status.activeServices || '0';
    }
    
    // Update service status indicators
    updateServiceIndicators(status.services);
}

// Update user statistics
function updateUserStats(stats) {
    const statsContainer = document.getElementById('userStats');
    if (statsContainer) {
        statsContainer.innerHTML = `
            <div class="stat-item">
                <strong>Total Users:</strong> ${stats.total || 0}
            </div>
            <div class="stat-item">
                <strong>Active Today:</strong> ${stats.activeToday || 0}
            </div>
            <div class="stat-item">
                <strong>Bandwidth Used:</strong> ${formatBytes(stats.bandwidthUsed || 0)}
            </div>
        `;
    }
}

// Update service status indicators
function updateServiceIndicators(services) {
    const indicators = {
        'nginx': document.getElementById('nginxStatus'),
        'dnstt': document.getElementById('dnsttStatus'),
        'ssh': document.getElementById('sshStatus'),
        'v2ray': document.getElementById('v2rayStatus')
    };
    
    for (const [service, element] of Object.entries(indicators)) {
        if (element && services && services[service]) {
            const isActive = services[service].status === 'active';
            element.className = `status-indicator ${isActive ? 'active' : 'inactive'}`;
            element.textContent = isActive ? '● Active' : '○ Inactive';
        }
    }
}

// Handle service control
async function handleServiceControl(event) {
    const action = event.target.dataset.action;
    const service = event.target.dataset.service;
    
    if (!action || !service) return;
    
    try {
        showLoading('services');
        
        const result = await simulateApiCall('service-control', {
            action: action,
            service: service
        });
        
        showNotification(`Service ${service} ${action}ed successfully`, 'success');
        loadServerStatus(); // Refresh status
        
    } catch (error) {
        console.error('Error controlling service:', error);
        showNotification(`Failed to ${action} ${service}`, 'error');
    }
}

// Handle user creation
async function handleUserCreation(event) {
    const protocol = event.target.dataset.protocol;
    
    if (!protocol) return;
    
    try {
        const username = prompt(`Enter username for ${protocol.toUpperCase()} user:`);
        if (!username) return;
        
        showLoading('users');
        
        const result = await simulateApiCall('create-user', {
            username: username,
            protocol: protocol
        });
        
        showNotification(`User ${username} created successfully`, 'success');
        showUserCredentials(result.credentials);
        loadUserStats(); // Refresh stats
        
    } catch (error) {
        console.error('Error creating user:', error);
        showNotification('Failed to create user', 'error');
    }
}

// Handle backup operations
async function handleBackup(event) {
    const action = event.target.dataset.action;
    
    try {
        showLoading('backup');
        
        const result = await simulateApiCall('backup', {
            action: action
        });
        
        if (action === 'create') {
            showNotification('Backup created successfully', 'success');
        } else if (action === 'restore') {
            showNotification('Backup restored successfully', 'success');
        }
        
    } catch (error) {
        console.error('Error performing backup:', error);
        showNotification('Backup operation failed', 'error');
    }
}

// Show user credentials
function showUserCredentials(credentials) {
    const modal = createCredentialsModal(credentials);
    document.body.appendChild(modal);
    
    // Show modal
    modal.style.display = 'block';
    
    // Close modal on background click
    modal.addEventListener('click', function(e) {
        if (e.target === modal) {
            modal.remove();
        }
    });
    
    // Copy to clipboard functionality
    const copyBtn = modal.querySelector('.copy-btn');
    if (copyBtn) {
        copyBtn.addEventListener('click', function() {
            copyToClipboard(credentials.text);
            showNotification('Credentials copied to clipboard', 'success');
        });
    }
}

// Create credentials modal
function createCredentialsModal(credentials) {
    const modal = document.createElement('div');
    modal.className = 'modal';
    modal.innerHTML = `
        <div class="modal-content">
            <div class="modal-header">
                <h3>🎉 User Created Successfully!</h3>
                <span class="close">&times;</span>
            </div>
            <div class="modal-body">
                <div class="credentials">
                    <h4>🔐 Connection Details</h4>
                    <pre>${credentials.text || 'No credentials available'}</pre>
                    
                    <div class="credential-actions">
                        <button class="btn copy-btn">📋 Copy to Clipboard</button>
                        <button class="btn download-btn">📥 Download Config</button>
                        <button class="btn qr-btn">📱 Show QR Code</button>
                    </div>
                </div>
                
                <div class="support-info">
                    <p><strong>📞 Support:</strong> ${CONFIG.SUPPORT_URL}</p>
                    <p><strong>⚡ Protocol:</strong> ${credentials.protocol || 'Unknown'}</p>
                </div>
            </div>
        </div>
    `;
    
    // Close button
    const closeBtn = modal.querySelector('.close');
    closeBtn.addEventListener('click', () => modal.remove());
    
    return modal;
}

// Copy to clipboard
function copyToClipboard(text) {
    navigator.clipboard.writeText(text).then(()
