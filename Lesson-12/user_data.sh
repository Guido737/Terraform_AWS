#!/bin/bash
set -euxo pipefail

# Update packages and install Apache
dnf -y update
dnf -y install httpd

# Get instance's private IP
myip=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Ensure document root exists
mkdir -p /var/www/html

# Create index.html
cat <<EOF > /var/www/html/index.html
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>My Terraform WebServer</title>
  <style>
    body {
      background: linear-gradient(-45deg, #0f2027, #203a43, #2c5364, #1a1a2e);
      background-size: 400% 400%;
      animation: gradient 15s ease infinite;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      color: #e0e0e0;
      text-align: center;
      padding: 5% 10%;
      margin: 0;
    }

    @keyframes gradient {
      0% {background-position: 0% 50%;}
      50% {background-position: 100% 50%;}
      100% {background-position: 0% 50%;}
    }

    h1 {
      font-size: 3rem;
      margin-bottom: 0.2em;
      text-shadow: 0 2px 5px rgba(0,0,0,0.5);
    }
    h2 {
      font-weight: 400;
      margin-top: 0;
      margin-bottom: 1em;
      text-shadow: 0 1px 3px rgba(0,0,0,0.4);
    }

    .footer {
      margin-top: 3em;
      font-size: 0.9rem;
      color: #cccccc;
      text-shadow: none;
    }

    .highlight {
      color: #00ffd5;
      font-weight: 700;
    }

    a {
      color: #00ffd5;
      text-decoration: none;
      border-bottom: 1px solid transparent;
      transition: border-color 0.3s;
    }

    a:hover {
      border-color: #00ffd5;
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
  <b>Version 2.1</b>
</body>
</html>
EOF

# Start and enable HTTPD
systemctl start httpd
systemctl enable httpd

# Log success
echo "User data script completed successfully" > /var/log/userdata-success.log
