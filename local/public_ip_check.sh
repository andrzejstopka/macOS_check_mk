#!/bin/bash

file="/var/tmp/public_ip4.dat"

if [ -f "$file" ]; then
    PUBLIC_IP4=`cat $file`
    echo 0 "Public_IP" IPv4=1 $PUBLIC_IP4
else
    echo 1 "Public_IP" IPv4=0 "Error: File does not exist"
fi
