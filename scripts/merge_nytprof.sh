#!/bin/bash

carton exec nytprofmerge --out /tmp/nytprof-merged.out /tmp/nytprof.out.*
carton exec nytprofhtml --minimal --delete --file /tmp/nytprof-merged.out -o /tmp/nytprof_report
