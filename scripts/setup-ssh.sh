#!/bin/sh

# Exit on errors
set -e

# Create .ssh directory
mkdir -p ~/.ssh

# Write the private key from the env variable
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519

# Add known hosts (GitHub)
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Optional: prevent host verification prompt
chmod 644 ~/.ssh/known_hosts

