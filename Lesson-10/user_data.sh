#!/bin/bash
set -euxo pipefail

# Update packages and install Apache
dnf -y update
dnf -y install httpd

# Get instance's private IP
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Create index.html
cat <<EOF > /var/www/html/index.html
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>My Terraform WebServer</title>
  <style>
    body {
      background: linear-gradient(135deg, #667eea, #764ba2);
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color: #f0f0f0;
      text-align: center;
      padding: 5% 10%;
      margin: 0;
    }
    h1 {
      font-size: 3rem;
      margin-bottom: 0.2em;
      text-shadow: 0 2px 5px rgba(0,0,0,0.3);
    }
    h2 {
      font-weight: 400;
      margin-top: 0;
      margin-bottom: 1em;
      text-shadow: 0 1px 3px rgba(0,0,0,0.2);
    }
    .footer {
      margin-top: 3em;
      font-size: 0.9rem;
      color: #cfcfcf;
      text-shadow: none;
    }
    .highlight {
      color: #ffd166;
      font-weight: 700;
    }
    a {
      color: #ffd166;
      text-decoration: none;
      border-bottom: 1px solid transparent;
      transition: border-color 0.3s;
    }
    a:hover {
      border-color: #ffd166;
    }
  </style>
</head>
<body>
  <h1>Welcome to My WebServer</h1><br>
  <h2>WebServer IP: <span class="highlight">$myip</span></h2>
  <p>Built by <strong>Terraform</strong> using External Script!</p>

  <div class="footer">
    <p>© 2025 Creator Eversor</p>
    <p><a href="https://github.com/creator-eversor" target="_blank" rel="noopener">GitHub</a></p>
  </div>
  <b>Version 3.0</b>
</body>
</html>
EOF

# Start and enable HTTPD
systemctl start httpd
systemctl enable httpd
