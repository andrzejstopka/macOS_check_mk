#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Error: This script must be run as root (use 'sudo')."
  exit 1
fi

if [ -z "$1" ]; then
    echo "Error: No brew check_mk directory path provided, usage: $0 <directory_path>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Error: Directory '$1' does not exist"
    exit 1
fi

cd "$1"

CHECK_MK_LOCAL_PATH="/usr/local/lib/check_mk_agent"

mkdir -p $CHECK_MK_LOCAL_PATH/local
cp agents/check_mk_agent.macos $CHECK_MK_LOCAL_PATH
cp -r agents/plugins/ $CHECK_MK_LOCAL_PATH
cp LaunchDaemon/de.mathias-kettner.check_mk.plist /Library/LaunchDaemons/
ln -s $CHECK_MK_LOCAL_PATH/check_mk_agent.macosx /usr/local/bin/check_mk_agent
mkdir /etc/check_mk

touch /var/run/de.arts-others.softwareupdatecheck
touch /var/log/check_mk.err

chmod +x $CHECK_MK_LOCAL_PATH/check_mk_agent.macosx
chmod o+rw /var/run/de.arts-others.softwareupdatecheck
chmod 666 /var/log/check_mk.err
chown -R root:admin $CHECK_MK_LOCAL_PATH
chmod 644 /Library/LaunchDaemons/de.mathias-kettner.check_mk.plist

launchctl load -w /Library/LaunchDaemons/de.mathias-kettner.check_mk.plist