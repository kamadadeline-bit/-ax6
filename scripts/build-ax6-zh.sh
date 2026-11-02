#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_SCRIPT="$ROOT_DIR/scripts/build.sh"

test -f "$BUILD_SCRIPT" || {
  echo "ERROR: build script not found: $BUILD_SCRIPT" >&2
  exit 1
}

python3 - "$BUILD_SCRIPT" <<'PY'
from pathlib import Path
import sys

path = Path(sys.argv[1])
text = path.read_text(encoding="utf-8")
marker = 'cat "$ROOT_DIR/configs/packages.common.config" "$DEVICE_CONFIG" > .config\nmake defconfig\n'
block = """cat "$ROOT_DIR/configs/packages.common.config" "$DEVICE_CONFIG" > .config
make defconfig

# Simplified Chinese LuCI: every selected translation must survive Kconfig.
for translation in \\
  luci-i18n-base-zh-cn \\
  luci-i18n-firewall-zh-cn \\
  luci-i18n-ppp-zh-cn \\
  luci-i18n-passwall-zh-cn \\
  luci-i18n-sqm-zh-cn \\
  luci-i18n-argon-config-zh-cn; do
  if ! grep -qx "CONFIG_PACKAGE_${translation}=y" .config; then
    echo "ERROR: required Simplified-Chinese LuCI translation ${translation} is missing or was dropped by Kconfig." >&2
    exit 1
  fi
done
echo "Simplified-Chinese LuCI package selection verified."
"""
if text.count(marker) != 1:
    raise SystemExit("ERROR: could not uniquely locate the post-defconfig insertion point; refusing to patch build.sh.")
if "required Simplified-Chinese LuCI translation" in text:
    raise SystemExit("ERROR: Chinese translation guard is already present; refusing duplicate injection.")
path.write_text(text.replace(marker, block, 1), encoding="utf-8")
print(f"Injected Simplified-Chinese LuCI Kconfig guard into {path}.")
PY

exec bash "$BUILD_SCRIPT"
