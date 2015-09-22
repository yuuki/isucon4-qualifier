#!/bin/bash

set -ex

WORKLOAD_NUM=$1

sudo service mysql restart
sudo rm -f /var/log/nginx/isucon4.access_log.tsv /var/log/nginx/access.log
sudo service nginx restart
/home/isucon/benchmark bench --workload $WORKLOAD_NUM
