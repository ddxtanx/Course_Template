#!/bin/bash

DOCUMENT=$1

if [ -z "$DOCUMENT" ]; then
  echo "Usage: $0 <document>"
  exit 1
fi

latexmk -pdflua -f -lualatex -interaction=nonstopmode -halt-on-error "$DOCUMENT"
# latexmk -c "$DOCUMENT"

