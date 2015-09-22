#!/bin/sh
set -ex
IPADDR=$1
ssh isucon@$IPADDR "cd ~/deploy && git pull && ~/deploy/scripts/env.sh carton install --deployment && sudo supervisorctl restart isucon_perl"
