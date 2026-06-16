#!/usr/bin/env bash
# Registers an existing folder of artifact files as an OpenSpec change.
# Usage: ./scripts/new-change-folder.sh <source-folder> [change-name]
#
# If change-name is omitted, it is derived from the source folder's basename.

set -euo pipefail

SOURCE_DIR="${1:-}"
CHANGE_NAME="${2:-}"

if [[ -z "$SOURCE_DIR" ]]; then
  echo "Usage: $0 <source-folder> [change-name]" >&2
  exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "Error: '$SOURCE_DIR' is not a directory" >&2
  exit 1
fi

SOURCE_DIR="$(cd "$SOURCE_DIR" && pwd)"

if [[ -z "$CHANGE_NAME" ]]; then
  CHANGE_NAME="$(basename "$SOURCE_DIR")"
fi

log() { echo "==> $*"; }

# Create the change via openspec
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

log "Creating change '$CHANGE_NAME'..."
openspec new change "$CHANGE_NAME"

CHANGE_DIR="$REPO_ROOT/openspec/changes/$CHANGE_NAME"

# Copy artifact files (skip hidden files like .openspec.yaml)
log "Copying files from $SOURCE_DIR..."
find "$SOURCE_DIR" -maxdepth 1 -type f -not -name '.*' -exec cp {} "$CHANGE_DIR/" \;

echo ""
log "Status..."
openspec status --change "$CHANGE_NAME"

echo ""
log "Validating..."
openspec validate "$CHANGE_NAME"
