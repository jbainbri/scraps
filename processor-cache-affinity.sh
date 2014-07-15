#!/bin/bash
#
# A script to find size and affinity of CPU cache levels
# When levels are equal, processors share cache affinity at that level
#
# (C) 2014 Red Hat, Inc.
#
NRCPUS=$(egrep -c "^processor" /proc/cpuinfo)
let NRCPUS-=1

for nr in $(seq 0 $NRCPUS); do
  for dir in $(ls /sys/devices/system/cpu/cpu$nr/cache/); do
    for file in level type size; do
      echo -n "$dir $file is "
      cat /sys/devices/system/cpu/cpu$nr/cache/$dir/$file
    done
  done
done
