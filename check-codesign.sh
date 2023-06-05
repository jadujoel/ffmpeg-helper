#!/bin/bash
# usage: check-codesign.sh
# checks if the files are code signed
source paths.sh
for path in "${paths[@]}"; do
  codesign -v --verify --deep --strict "${path}"
done
