#!/bin/bash
#
# A bash script to balance interrupts on processors.
# Allows specifying first/last core/IRQ for balancing specific devices into
# specific places on dual NUMA and interleave dual NUMA systems.
#
# (C) 2017 Red Hat, Inc.
# License: Creative Commons Zero

if [[ $# != 5 ]]; then
    echo "Usage: $0 [first core] [last core] [first IRQ] [last IRQ] [step]"
    exit 1;
fi

CMD=echo  ## change this to "eval" to run for real, or just copypaste the output
C_FIRST=$1
C_LAST=$2
I_FIRST=$3
I_LAST=$4
STEP=$5

echo "CPUs: $C_FIRST to $C_LAST"
echo "IRQs: $I_FIRST to $I_LAST"
echo "Step: $STEP"

let CPU=C_FIRST

for IRQ in $(seq $I_FIRST $I_LAST);do
    $CMD "echo $(($CPU)) > /proc/irq/$IRQ/smp_affinity_list";
    let CPU+=STEP
    if (( CPU > C_LAST )); then
        let CPU=C_FIRST
    fi
done
