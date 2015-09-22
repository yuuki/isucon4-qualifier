#!/bin/bash

nytprofmerge --out /tmp/nytprof-merged.out /tmp/nytprof.out.*
nytprofhtml --minimal --delete --file /tmp/nytprof-merged.out
