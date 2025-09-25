#!/bin/bash
set -e

sh ./scripts/setup-ssh.sh

# git clone git@github.com:blueiberis/apis-django-fe.git app

rm -rf app || true

GIT_SSH_COMMAND='ssh -i /vercel/.ssh/id_ed25519 -o StrictHostKeyChecking=no' git clone git@github.com:blueiberis/apis-django-fe.git app

cd app

npm install
npm run build

cp -r .next ../.next

