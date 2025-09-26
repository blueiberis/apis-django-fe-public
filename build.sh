#!/bin/bash
set -e

sh ./scripts/setup-ssh.sh

# git clone git@github.com:blueiberis/apis-django-fe.git app
shopt -s extglob  # Enable extended globbing (bash)
rm -rf !(scripts/setup-ssh.sh|vercel.jsoni|build.sh)

GIT_SSH_COMMAND='ssh -i /vercel/.ssh/id_ed25519 -o StrictHostKeyChecking=no' git clone git@github.com:blueiberis/apis-django-fe.git app

# Remove the .git folder inside app to avoid overwriting root's git info
rm -rf .git
rm -rf .vercel
rm -rf app/.git

# Copy everything (including hidden files except .git) to root
ls -al
cp -r app/. ./

npm install
npm run build

rm -rf !(scripts/setup-ssh.sh|vercel.jsoni|build.sh|.next|package.json)
