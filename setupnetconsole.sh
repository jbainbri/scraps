#!/bin/bash
#
# setupnetconsole.sh
# a script to setup netconsole
#
# just set these variables and you're good to go
LEVEL="8"
LOCALDEV="em1"
REMOTEIP="10.0.0.0"
REMOTEMAC="00:00:00:00:00:00"
# if the remoteip is not in the same subnet, use the gateway's mac so traffic routes

echo "raising kernel logging level to $LEVEL"
dmesg -n "$LEVEL"

if [ "$(lsmod | grep -c configfs)" -gt 0 ]; then
  echo "configfs already loaded"
else
  echo "loading configfs"
  modprobe configfs
fi

if [ "$(lsmod | grep -c netconsole)" -gt 0 ]; then
  echo "netconsole already loaded"
else
  echo "loading netconsole"
  modprobe netconsole
fi

if [ "$(mount | grep -c "type configfs")" -gt 0 ]; then
  echo "configfs already mounted"
else
  echo "mounting configfs"
  mount none -t configfs /sys/kernel/config
fi

# setup a target
if [ -d /sys/kernel/config/netconsole/target1 ]; then
  echo "netconsole target directory already exists"
else
  echo "making netconsole target directory"
  mkdir /sys/kernel/config/netconsole/target1
fi

echo "0" > /sys/kernel/config/netconsole/target1/enabled

echo "$LOCALDEV" > /sys/kernel/config/netconsole/target1/dev_name
echo -n "/sys/kernel/config/netconsole/target1/dev_name = "; cat /sys/kernel/config/netconsole/target1/dev_name

echo "$(ifdata -pa "$LOCALDEV")" > /sys/kernel/config/netconsole/target1/local_ip
echo -n "/sys/kernel/config/netconsole/target1/local_ip = "; cat /sys/kernel/config/netconsole/target1/local_ip

echo "$REMOTEIP" > /sys/kernel/config/netconsole/target1/remote_ip
echo -n "/sys/kernel/config/netconsole/target1/remote_ip = "; cat /sys/kernel/config/netconsole/target1/remote_ip

echo "$REMOTEMAC" > /sys/kernel/config/netconsole/target1/remote_mac
echo -n "/sys/kernel/config/netconsole/target1/remote_mac = "; cat /sys/kernel/config/netconsole/target1/remote_mac

echo "enabling..."
echo "1" > /sys/kernel/config/netconsole/target1/enabled

