#!/bin/bash
#
# A basic bash script to balance interrupts on processors.
# Probably not sufficient for all purposes, but provides an example and a base to build off.
#
# (C) 2014 Red Hat, Inc.
#
CMD=echo  ## change this to eval for real
CORES=$(egrep -c "^processor" /proc/cpuinfo); echo "CORES=$CORES";
IRQ=$(awk '/0:/,/NMI/' /proc/interrupts | wc -l); echo "IRQ=$IRQ";
IRQ=$(($IRQ-1)); echo "IRQ=$IRQ";
for i in $(seq 0 $IRQ); do $CMD "echo $(($i%$CORES)) > /proc/irq/$i/smp_affinity_list"; done
