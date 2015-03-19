#!/usr/bin/env bash

CWD=`pwd`

set -e
trap 'STATUS=$?; cd "$CWD"; exit $STATUS' ERR

DEPS_DIR="`cd .. && pwd`/chmsee-deps"
PAC_CONF="$DEPS_DIR/pacman.conf"
ARCH_DIR="$DEPS_DIR/arch-root"
DB_DIR="$ARCH_DIR/var/lib/pacman"
CACHE_DIR="$ARCH_DIR/var/cache/pacman/pkg"
LOG_DIR="$ARCH_DIR/var/log"

cat > "$PAC_CONF" << EOF
[options]
RootDir = $ARCH_DIR
DBPath = $DB_DIR
CacheDir = $CACHE_DIR
LogFile = $LOG_DIR/pacman.log
SigLevel = Never
Architecture = auto

[core]
Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch

[extra]
Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch

[community]
Server = http://mirror.rackspace.com/archlinux/\$repo/os/\$arch

EOF

cat "$PAC_CONF"

mkdir -p "$ARCH_DIR"
mkdir -p "$DB_DIR"
mkdir -p "$CACHE_DIR"
mkdir -p "$LOG_DIR"

sudo pacman --config "$PAC_CONF" --noconfirm --noprogressbar -Sy
sudo pacman --config "$PAC_CONF" --noconfirm --noprogressbar -S base-devel xulrunner

cd "$CWD"
