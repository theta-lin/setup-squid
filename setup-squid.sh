#/bin/sh

set -e
sudo apt update
sudo apt install ufw squid apache2-utils -y

# Set firewall rules
sudo ufw allow OpenSSH
sudo ufw allow Squid
sudo ufw enable

# Create a user with username "user" and prompt the input of a password
sudo htpasswd -c /etc/squid/passwords user

# Allow only authenticated users
sudo sed -i '/YOUR OWN RULE/{
n
n
a\auth_param basic program /usr/lib/squid3/basic_ncsa_auth /etc/squid/passwords
a\auth_param basic realm proxy
a\acl authenticated proxy_auth REQUIRED
}' /etc/squid/squid.conf
sudo sed -i 's/http_access deny all/http_access allow authenticated/' /etc/squid/squid.conf

sudo systemctl restart squid.service
