#!/bin/bash

export NYTPROF="sigexit=int:start=no:addpid=1:forkdepth=0:file=/tmp/nytprof.out"
exec carton exec start_server --path /dev/shm/app.sock --backlog 16384 -- perl -d:NYTProf local/bin/plackup -s Gazelle --path /dev/shm/app.sock --max-reqs-per-child 50000 -workers=4 -E prod app.psgi
