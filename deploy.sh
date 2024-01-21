#!/bin/bash

# Secrets
DOMAIN=""
KEYSTORE_PASS=""
OPENAI_API_KEY=""

# Step 1 - Copy firebase_credentials.json file
cp firebase_credentials.json source-code/src/main/java/edu/brown/cs/student/main/server/config/

# Step 2 - Make temp file with keystore password
(echo $KEYSTORE_PASS) > /tmp/keystore_TEMP.txt

# Step 3 - Build syntax-backend Docker container 
sudo docker buildx build --secret id=cert_fullchain,src=/etc/letsencrypt/live/$DOMAIN/fullchain.pem \
                  --secret id=cert_privkey,src=/etc/letsencrypt/live/$DOMAIN/privkey.pem \
                  --secret id=keystore_pass,src=/tmp/keystore_TEMP.txt -t syntax-backend .

# Step 4 - Delete temporary keystore file
rm /tmp/keystore_TEMP.txt

# Step 5 - Run the Docker container
sudo docker run -e KEYSTORE_PASS=$KEYSTORE_PASS -e OPENAI_API_KEY=$OPENAI_API_KEY -p 443:443 syntax-backend