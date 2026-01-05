#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="MarkdownPreviewer.app"
VOLUME_NAME="Markdown Preview"
DIST_DIR="${ROOT_DIR}/dist"
BUILD_DIR="${ROOT_DIR}/build"
ASSETS_DIR="${ROOT_DIR}/assets"
BG_IMAGE="${ASSETS_DIR}/dmg-background.png"

usage() {
  echo "Usage:"
  echo "  $(basename "$0") --build"
  echo "  $(basename "$0") /path/to/${APP_NAME}"
  exit 1
}

APP_PATH=""
if [[ "${1:-}" == "--build" ]]; then
  xcodebuild \
    -project "${ROOT_DIR}/MarkdownPreviewer.xcodeproj" \
    -scheme MarkdownPreviewer \
    -configuration Release \
    -derivedDataPath "${BUILD_DIR}" \
    clean build
  APP_PATH="${BUILD_DIR}/Build/Products/Release/${APP_NAME}"
elif [[ $# -eq 1 ]]; then
  APP_PATH="$1"
else
  usage
fi

if [[ ! -d "${APP_PATH}" ]]; then
  echo "App not found at: ${APP_PATH}"
  exit 1
fi

if [[ ! -f "${BG_IMAGE}" ]]; then
  python3 "${ROOT_DIR}/scripts/generate_assets.py"
fi

mkdir -p "${DIST_DIR}"
STAGING_DIR="$(mktemp -d "${DIST_DIR}/dmg-staging.XXXXXX")"
RW_DMG="${DIST_DIR}/MarkdownPreview.tmp.dmg"
MOUNT_DIR=""
cleanup() {
  if [[ -n "${MOUNT_DIR}" ]]; then
    hdiutil detach "${MOUNT_DIR}" -quiet || true
  fi
  rm -f "${RW_DMG}"
  rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

cp -R "${APP_PATH}" "${STAGING_DIR}/"
ln -s /Applications "${STAGING_DIR}/Applications"

DMG_PATH="${DIST_DIR}/MarkdownPreview.dmg"
rm -f "${DMG_PATH}"

hdiutil create \
  -volname "${VOLUME_NAME}" \
  -srcfolder "${STAGING_DIR}" \
  -fs HFS+ \
  -format UDRW \
  -size 160m \
  "${RW_DMG}" >/dev/null

MOUNT_DIR=$(hdiutil attach -readwrite -noverify -noautoopen "${RW_DMG}" | awk '/\/Volumes/ {print $3; exit}')

mkdir -p "${MOUNT_DIR}/.background"
cp "${BG_IMAGE}" "${MOUNT_DIR}/.background/background.png"

for attempt in 1 2 3 4 5; do
  if osascript <<EOF
tell application "Finder"
  repeat until exists disk "${VOLUME_NAME}"
    delay 0.5
  end repeat
  tell disk "${VOLUME_NAME}"
    open
    delay 1
    set dmgWindow to container window
    set current view of dmgWindow to icon view
    set toolbar visible of dmgWindow to false
    set statusbar visible of dmgWindow to false
    set the bounds of dmgWindow to {100, 100, 740, 500}
    set viewOptions to the icon view options of dmgWindow
    set arrangement of viewOptions to not arranged
    set icon size of viewOptions to 128
    set background picture of viewOptions to file ".background:background.png"
    set position of item "${APP_NAME}" to {180, 210}
    set position of item "Applications" to {460, 210}
    close dmgWindow
    open
    update without registering applications
    delay 1
  end tell
end tell
EOF
  then
    break
  fi
  sleep 1
done

hdiutil detach "${MOUNT_DIR}" -quiet
rmdir "${MOUNT_DIR}" 2>/dev/null || true

hdiutil convert "${RW_DMG}" -format UDZO -imagekey zlib-level=9 -o "${DMG_PATH}" >/dev/null

echo "Created: ${DMG_PATH}"
