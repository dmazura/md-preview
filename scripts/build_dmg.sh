#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="MarkdownPreviewer.app"
VOLUME_NAME="Markdown Preview"
DIST_DIR="${ROOT_DIR}/dist"
BUILD_DIR="${ROOT_DIR}/build"

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

mkdir -p "${DIST_DIR}"
STAGING_DIR="$(mktemp -d "${DIST_DIR}/dmg-staging.XXXXXX")"
trap 'rm -rf "${STAGING_DIR}"' EXIT

cp -R "${APP_PATH}" "${STAGING_DIR}/"
ln -s /Applications "${STAGING_DIR}/Applications"

DMG_PATH="${DIST_DIR}/MarkdownPreview.dmg"
rm -f "${DMG_PATH}"
hdiutil create \
  -volname "${VOLUME_NAME}" \
  -srcfolder "${STAGING_DIR}" \
  -fs HFS+ \
  -format UDZO \
  "${DMG_PATH}" >/dev/null

echo "Created: ${DMG_PATH}"
