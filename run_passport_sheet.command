#!/bin/zsh

set -euo pipefail

WORKDIR="/Users/raymondleung/Documents/New project 2"
SCRIPT_PATH="$WORKDIR/make_4x6_sheet.swift"

cd "$WORKDIR"

echo "4x6 Passport Sheet Generator"
echo
read "INPUT_PATH?Enter the full path to your square image: "

if [[ ! -f "$INPUT_PATH" ]]; then
  echo
  echo "File not found: $INPUT_PATH"
  read "DONE?Press Enter to close..."
  exit 1
fi

echo
read "OUTPUT_NAME?Enter output file name [passport_sheet.jpg]: "
OUTPUT_NAME="${OUTPUT_NAME:-passport_sheet.jpg}"

echo
echo "Generating $OUTPUT_NAME ..."
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache swift "$SCRIPT_PATH" "$INPUT_PATH" "$OUTPUT_NAME"
echo
echo "Done."
echo "Saved to: $WORKDIR/$OUTPUT_NAME"
read "DONE?Press Enter to close..."
