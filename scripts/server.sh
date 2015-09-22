#!/bin/bash

export NYTPROF="sigexit=int:start=no:addpid=1:forkdepth=0:file=/tmp/nytprof.out"
exec carton exec perl -d:NYTProf local/bin/plackup -s Starman --host localhost:8080 -E prod app.psgi
