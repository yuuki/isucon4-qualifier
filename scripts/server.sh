#!/bin/bash

NYTPROF="sigexit=int:savesrc=0:start=no:addpid=1:forkdepth=0:file=/tmp/nytprof.out"
exec carton exec plackup -d:NYTProf -s Starman --host localhost:8080 -E prod app.psgi
