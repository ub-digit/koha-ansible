#!/usr/bin/env bash

if test "$2" = ""
then
  echo "Usage: $0 patch-dir root-dir"
  exit
fi

PATCHDIR="$1"
ROOTDIR="$2"
cd "$ROOTDIR"

if ls "$PATCHDIR"/*.diff 2> /dev/null
then
  ls "$PATCHDIR"/*.diff | while read pt
  do
    cat "$pt" | patch -p0
  done
fi

