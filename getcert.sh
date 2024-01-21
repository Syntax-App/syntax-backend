#!/bin/bash

# Certificate-Related Variables
DOMAIN=""
EMAIL=""
WEBROOT="/var/www/html" # Path to the webroot of your domain

# Run Certbot for HTTP-01 challenge
sudo certbot certonly --webroot -w $WEBROOT -d $DOMAIN -m $EMAIL --agree-tos --non-interactive