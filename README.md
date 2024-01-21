# Backend for Syntax

## Step 1: Obtaining a certificate for your domain
- Edit `getcert.sh` and provide values for the following environment variables: `DOMAIN` and `EMAIL`. These will be used to issue a Let's Encrypt certificate.
- Run `sudo bash getcert.sh`.
Note that for this process to work, your domain must point to the machine where you are running the server.

## Step 2: Preparing to build the Docker Container
- Edit `deploy.sh` and provide values for `DOMAIN` (the domain you got a certificate for), `KEYSTORE_PASS` (a password for the keystore containing SSL certificate information), and `OPENAI_API_KEY` (the OpenAI secret key).
- Provide a "firebase_credentials.json" file. You should be able to find this on the Firebase admin console.

## Step 3: Building and running the Docker Container
- Run `sudo bash deploy.sh`
- Congratulations!
