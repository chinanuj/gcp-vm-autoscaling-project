#!/bin/bash
# Startup script for VM instances

# Update package information
apt-get update

# Install nginx web server and stress test tool
apt-get install -y nginx stress

# Create custom index page with instance name
HOSTNAME=$(hostname)
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Instance Information</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 40px;
            text-align: center;
        }
        .container {
            background-color: #f0f0f0;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        h1 {
            color: #4285f4;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>GCP Auto-scaling Demo</h1>
        <h2>Instance: ${HOSTNAME}</h2>
        <p>This instance was created by the auto-scaling managed instance group.</p>
        <p>Current time: $(date)</p>
    </div>
</body>
</html>
EOF

# Make sure nginx is running
systemctl enable nginx
systemctl restart nginx