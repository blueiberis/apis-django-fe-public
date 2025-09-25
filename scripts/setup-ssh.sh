#!/bin/sh
set -e

echo "Setting up SSH..."

mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519

echo "SSH key first lines:"
head -n 3 ~/.ssh/id_ed25519
echo "..."

echo "Creating SSH config..."
cat > ~/.ssh/config << EOF
Host github.com
  HostName github.com
  IdentityFile ~/.ssh/id_ed25519
  StrictHostKeyChecking no
EOF
chmod 600 ~/.ssh/config

echo "Adding github.com to known_hosts..."
ssh-keyscan github.com >> ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

echo "Validating SSH key pair..."

# Regenerate public key from the private key
echo "Generated public key from private key:"
ssh-keygen -y -f ~/.ssh/id_ed25519

# Show fingerprint (SHA256) for double-checking
echo "Public key fingerprint (SHA256):"
ssh-keygen -lf ~/.ssh/id_ed25519

echo "Validation done."

echo "known_hosts contents:"
cat ~/.ssh/known_hosts

echo "Testing SSH connection to github.com..."
ssh -o StrictHostKeyChecking=no -T git@github.com

echo "SSH setup done."

