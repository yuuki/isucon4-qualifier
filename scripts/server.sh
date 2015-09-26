#!/bin/bash

exec carton exec start_server --path /dev/shm/app.sock --backlog 16384 -- perl -d:NYTProf local/bin/plackup -s Gazelle --max-reqs-per-child 50000 -workers=4 -E prod app.psgi
