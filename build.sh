#!/bin/bash
set -e

sh ./scripts/setup-ssh.sh

git clone git@github.com:blueiberis/apis-django-fe.git app

cd app

npm install
npm run build

