#!/bin/sh

# Make /var/lib/rancher persistent
MOUNT_POINT="/mnt/data"
mkdir -p /var/lib/rancher
if [ ! -L /var/lib/rancher ]; then
  if [ ! -d "${MOUNT_POINT}/var/lib/rancher" ]; then
    mkdir -p "${MOUNT_POINT}/var/lib"
    mv /var/lib/rancher "${MOUNT_POINT}/var/lib/rancher"
  else
    rm -rf /var/lib/rancher
  fi
  ln -s "${MOUNT_POINT}/var/lib/rancher" /var/lib/rancher
fi

# Stop Docker to release cgroups
for i in {1..10}; do
  if /etc/init.d/docker status > /dev/null 2>&1; then
    break
  fi
  sleep 0.5
done
/etc/init.d/docker stop
