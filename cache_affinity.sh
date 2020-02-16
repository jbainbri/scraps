#!/bin/bash
# cache_affinity.sh
#
# This script walks sysfs and determines the level, type, and size of each
# processor cache. It then reports which processor cores each cache level
# is shared with.
#
# (C) 2014-2020 Red Hat, Inc.
# License: Creative Commons Zero

PROCPATH="/proc/cpuinfo"
SYSPATH="/sys/devices/system/cpu"
if [[ -a ./proc/cpuinfo && -a ./sys/devices/system/cpu ]]; then
    PROCPATH="./proc/cpuinfo"
    SYSPATH="./sys/devices/system/cpu"
fi

NRCPUS=$(egrep -c "^processor" "$PROCPATH")
let NRCPUS=$NRCPUS-1

for CPU in $(seq 0 $NRCPUS); do
  echo "Processor $CPU"
  for LEVEL in $(ls "$SYSPATH/cpu$CPU/cache/"); do
    for FILE in level type size; do
      echo -n "$LEVEL $FILE is "
      cat "$SYSPATH/cpu$CPU/cache/$LEVEL/$FILE"
    done
  done
  echo
done

INDEXES=$(eval ls -d "$SYSPATH/cpu0/cache/index*" | wc -l)
let INDEXES=$INDEXES-1

for CPU in $(seq 0 $NRCPUS); do
  echo "Processor $CPU"
  for INDEX in $(seq 0 $INDEXES); do
    echo -n "CPU $CPU, Index $INDEX = "
    cat "$SYSPATH/cpu$CPU/cache/index$INDEX/shared_cpu_map"
  done
done
