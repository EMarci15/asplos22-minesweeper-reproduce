#!/bin/bash

sudo apt install python3 python3-pip gcc make
pip install psrecord psutil numpy pandas io

# DEFINITIONS
# psrecord executable
export PSREC=~/.local/bin/psrecord
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
ln -sf ~/.local/bin/psrecord ../psrecord
ln -sf /usr/lib/x86_64-linux-gnu/libdl.so ../lib/libdl.so

