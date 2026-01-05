#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ICON_SRC="${ROOT_DIR}/assets/icon-1024.png"
ICONSET_DIR="${ROOT_DIR}/MarkdownPreviewer/Assets.xcassets/AppIcon.appiconset"

if [[ ! -f "${ICON_SRC}" ]]; then
  echo "Missing ${ICON_SRC}. Run: python3 scripts/generate_assets.py"
  exit 1
fi

mkdir -p "${ICONSET_DIR}"

generate() {
  local size="$1"
  local scale="$2"
  local out="$3"
  local pixels=$((size * scale))
  sips -z "${pixels}" "${pixels}" "${ICON_SRC}" --out "${ICONSET_DIR}/${out}" >/dev/null
}

generate 16 1 icon_16x16.png
generate 16 2 icon_16x16@2x.png
generate 32 1 icon_32x32.png
generate 32 2 icon_32x32@2x.png
generate 128 1 icon_128x128.png
generate 128 2 icon_128x128@2x.png
generate 256 1 icon_256x256.png
generate 256 2 icon_256x256@2x.png
generate 512 1 icon_512x512.png
generate 512 2 icon_512x512@2x.png

echo "Generated icons in ${ICONSET_DIR}"
