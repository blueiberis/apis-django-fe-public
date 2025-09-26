#!/bin/bash
set -e

setup_ssh() {
	echo "Setting up SSH..."

	mkdir -p ~/.ssh
	echo "$SSH_PRIVATE_KEY_BASE64" | base64 -d > ~/.ssh/id_ed25519
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
	IdentitiesOnly yes
EOF
	chmod 600 ~/.ssh/config

	cat ~/.ssh/config

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

	eval $(ssh-agent -s)
	ssh-add ~/.ssh/id_ed25519

	echo "Testing SSH connection to github.com..."
	ssh -o StrictHostKeyChecking=no -T git@github.com || true

	echo "SSH setup done."
}

setup_ssh

shopt -s extglob  # Enable extended globbing (bash)
rm -rf !(vercel.json|build.sh|package.json)
rm -rf .git
rm -rf .vercel

# GIT_SSH_COMMAND='ssh -i /vercel/.ssh/id_ed25519 -o StrictHostKeyChecking=no' git clone git@github.com:blueiberis/apis-django-fe.git app
git clone git@github.com:blueiberis/apis-django-fe.git app

# Remove the .git folder inside app to avoid overwriting root's git info
rm -rf app/.git
rm -rf app/.husky
echo "Removing 'prepare': 'husky' from app/package.json..."
sed -i '/"prepare": *"husky",*/d' app/package.json

# Copy everything (including hidden files except .git) to root
cp -r app/. ./
cat package.json

npm install
#npm run build
next build

ls -al .next

rm -rf !(vercel.json|build.sh|.next|package.json)

