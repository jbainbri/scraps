#!/bin/bash
#
# A bash script to balance interrupts on processors.
# Allows specifying a number of cores to use, the first core, and whether to interleave cores
#
# (C) 2017 Red Hat, Inc.
# License: Creative Commons Zero
#
# Examples:
#
# 22 cores, IRQ 150 to 172, Interleave NUMA, start on core 0
# script.sh 22 150 172 1 0
#
# 22 cores, IRQ 150 to 172, Interleave NUMA, start on core 1
# script.sh 22 150 172 1 1

if [[ $# != 5 ]]; then
    echo "Usage: $0 [cores] [first IRQ] [last IRQ] [interleave 0|1] [first core 0|1]"
    exit 1;
fi

CMD=echo  ## change this to eval for real
CORES=$1
IRQA=$2
IRQB=$3
INTR=$4
FIRST=$5
STEP=1

echo "CPU Cores=$CORES"
echo "First Core=$FIRST"
echo "First IRQ=$IRQA"
echo "Last IRQ=$IRQB"

if [[ $INTR == 1 ]]; then
    let STEP+=1
    IMSG="Using" 
else
    IMSG="Not using"
fi

echo "$IMSG interleave, STEP=$STEP"

let CPU=FIRST

for IRQ in $(seq $IRQA $IRQB);do
    $CMD "echo $(($CPU)) > /proc/irq/$IRQ/smp_affinity_list";
    let CPU+=STEP
    if (( CPU > CORES )); then
        let CPU=-1
        let CPU+=STEP
    fi
done
