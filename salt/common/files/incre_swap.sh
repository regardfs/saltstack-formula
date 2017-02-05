#!/bin/sh

# size of swapfile in megabytes
{% set swapsize=salt['pillar.get']('swapspace', 4096) %}

# does the swap file already exist?
grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
      echo 'swapfile not found. Adding swapfile.'
      fallocate -l {{ swapsize }}M /swapfile
      chmod 600 /swapfile
      mkswap /swapfile
      swapon /swapfile
      if [ -e /swapfile ]; then
        echo '/swapfile none swap defaults 0 0' >> /etc/fstab
      else
        echo 'Swapfile create failed,Please check...'
      fi
else
      echo 'swapfile found. No changes made.'
fi

# output results to terminal
df -h
cat /proc/swaps
cat /proc/meminfo | grep Swap