#!/usr/bin/env bash

for c in `seq 100`
do
    ./fetch_snap.sh; sleep 60;
done
