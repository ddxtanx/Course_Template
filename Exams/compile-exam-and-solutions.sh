#!/bin/bash

DOCUMENT=$1

if [ -z "$DOCUMENT" ]; then
  echo "Usage: $0 <document>"
  exit 1
fi

DOCUMENT_EXAM="${DOCUMENT/.tex/-exam.tex}"
DOCUMENT_SOLUTIONS="${DOCUMENT/.tex/-solutions.tex}"

# Compile exam
cp "$DOCUMENT" "$DOCUMENT_EXAM"
../../compile-wrapper.sh "$DOCUMENT_EXAM"

rm "$DOCUMENT_EXAM"

# Compile solutions
sed 's/\\documentclass\[addpoints,12pt\]{exam}/\\documentclass[addpoints,12pt,answers]{exam}/' "$DOCUMENT" > "$DOCUMENT_SOLUTIONS"
../../compile-wrapper.sh "$DOCUMENT_SOLUTIONS"

rm "$DOCUMENT_SOLUTIONS"
