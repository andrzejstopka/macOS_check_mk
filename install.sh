#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (use 'sudo')."
  exit 1
fi

cd "$(dirname "$0")" || { echo "Error: Failed to change directory to $(dirname "$0")"; exit 1; }

CHECK_MK_LOCAL_PATH="/usr/local/lib/check_mk_agent"

mkdir -p $CHECK_MK_LOCAL_PATH
cp -r local $CHECK_MK_LOCAL_PATH
cp agents/check_mk_agent.macosx $CHECK_MK_LOCAL_PATH
cp -r agents/plugins/* $CHECK_MK_LOCAL_PATH
cp LaunchDaemon/de.mathias-kettner.check_mk.plist /Library/LaunchDaemons/
if [ ! -e /usr/local/bin/check_mk_agent ]; then
	ln -s $CHECK_MK_LOCAL_PATH/check_mk_agent.macosx /usr/local/bin/check_mk_agent
fi
mkdir -p /etc/check_mk

touch /var/run/de.arts-others.softwareupdatecheck
touch /var/log/check_mk.err

chmod +x $CHECK_MK_LOCAL_PATH/check_mk_agent.macosx
chmod o+rw /var/run/de.arts-others.softwareupdatecheck
chmod 666 /var/log/check_mk.err
chown -R root:admin $CHECK_MK_LOCAL_PATH
chmod 644 /Library/LaunchDaemons/de.mathias-kettner.check_mk.plist
