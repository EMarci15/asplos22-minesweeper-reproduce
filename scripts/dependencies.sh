#!/bin/bash

echo "===== Installing dependencies"

export DEPENDENCIES="python3 python3-pip gcc make autoconf sudo"

if command -v sudo >/dev/null
then
  sudo apt install $DEPENDENCIES
  sudo sysctl vm.max_map_count=655300
else
  apt install $DEPENDENCIES
  sysctl vm.max_map_count=655300
fi

pip3 install psrecord psutil numpy pandas

# DEFINITIONS
# psrecord executable
export PSREC=~/.local/bin/psrecord
if [ ! -f "$PSREC" ]; then
  # It's not in the user's local directory. Maybe it's already installed system-wide? (e.g. su mode on a docker image)
  export PSREC=($(whereis psrecord))
  export PSREC=${PSREC[1]}
fi

# libdl library
export LIBDL=/usr/lib/x86_64-linux-gnu/libdl.so

# CHECKS
if [ ! -f "$PSREC" ]; then
  echo "psrecord executable not found!"
  echo "Please fix the DEFINITIONS in scripts/dependencies.sh"
  exit 1
fi

if [ ! -f "$LIBDL" ]; then
  echo "libdl.so not found!"
  echo "Please fix the DEFINITIONS in scripts/dependencies.sh"
  exit 2
fi


# CREATE SYMLINKS
mkdir -p ../lib
ln -sf $PSREC ../psrecord
ln -sf $LIBDL ../lib/libdl.so

echo "===== Done installing dependencies"

