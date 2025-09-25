#!/bin/sh
set -e

echo "Setting up SSH..."

mkdir -p ~/.ssh
echo "$SSH_PRIVATE_KEY" > ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_ed25519

echo "SSH key first lines:"
head -n 3 ~/.ssh/id_ed25519
echo "..."

echo "Adding github.com to known_hosts..."
ssh-keyscan github.com >> ~/.ssh/known_hosts
chmod 644 ~/.ssh/known_hosts

echo "known_hosts contents:"
cat ~/.ssh/known_hosts

echo "Testing SSH connection to github.com..."
ssh -o StrictHostKeyChecking=no -T git@github.com || true

echo "SSH setup done."

