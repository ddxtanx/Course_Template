#!/bin/bash

DOCUMENT=$1

if [ -z "$DOCUMENT" ]; then
  echo "Usage: $0 <document>"
  exit 1
fi

DOCUMENT_QUIZ="${DOCUMENT/.tex/-quiz.tex}"
DOCUMENT_SOLUTIONS="${DOCUMENT/.tex/-solutions.tex}"

# Compile slides
cp "$DOCUMENT" "$DOCUMENT_QUIZ"
../../compile-wrapper.sh "$DOCUMENT_QUIZ"

rm "$DOCUMENT_QUIZ"

# Compile handout
sed 's/\\documentclass\[addpoints,12pt\]{exam}/\\documentclass[addpoints,12pt,answers]{exam}/' "$DOCUMENT" > "$DOCUMENT_SOLUTIONS"
../../compile-wrapper.sh "$DOCUMENT_SOLUTIONS"

rm "$DOCUMENT_SOLUTIONS"
