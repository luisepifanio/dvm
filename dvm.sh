#!/usr/bin/env sh
echo "▶▶ loading DVM..."

if [ -d "$DVM_DIR/bin" ] && [ -f "$DVM_DIR/bin/.settings" ]; then
   . "$DVM_DIR/bin/.settings"
fi
