#!/usr/bin/env bash

for c in `seq 30`
do
    ./fetch_snap.sh; sleep 60;
done
