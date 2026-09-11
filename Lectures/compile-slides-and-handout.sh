#!/bin/bash

DOCUMENT=$1

if [ -z "$DOCUMENT" ]; then
  echo "Usage: $0 <document>"
  exit 1
fi

DOCUMENT_SLIDES="${DOCUMENT/.tex/-slides.tex}"
DOCUMENT_HANDOUT="${DOCUMENT/.tex/-handout.tex}"

# Compile slides
cp "$DOCUMENT" "$DOCUMENT_SLIDES"
../../compile-wrapper.sh "$DOCUMENT_SLIDES"
rm "$DOCUMENT_SLIDES"

# Compile handout
sed 's/\\documentclass{ltx-talk}/\\documentclass[mode=handout]{ltx-talk}/' "$DOCUMENT" > "$DOCUMENT_HANDOUT"
../../compile-wrapper.sh "$DOCUMENT_HANDOUT"

rm "$DOCUMENT_HANDOUT"
