#!/usr/bin/env sh
echo " => loading DVM..."

echo "\$DVM_DIR/bin => $DVM_DIR/bin"
echo "\$DVM_DIR/bin/.settings => $DVM_DIR/bin/.settings"

if [ -d "$DVM_DIR/bin" ] && [ -f "$DVM_DIR/bin/.settings" ]; then
   . "$DVM_DIR/bin/.settings"
fi