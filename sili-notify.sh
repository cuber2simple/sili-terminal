#!/bin/bash
# Sili Terminal - AI Notification System
# ======================================
# Usage: sili-notify "message" [level]
# Levels: info, warn, error, ai

NOTIFY_LOG="/tmp/sili-notify.log"
TIMESTAMP=$(date '+%H:%M:%S')

LEVEL="${2:-info}"

case "$LEVEL" in
  info)   ICON="[>]" COLOR="" ;;
  warn)   ICON="[!]" COLOR="" ;;
  error)  ICON="[x]" COLOR="" ;;
  ai)     ICON="[~]" COLOR="" ;;
  *)      ICON="[*]" COLOR="" ;;
esac

echo "${ICON} ${TIMESTAMP} | $1" >> "$NOTIFY_LOG"

# Also send macOS notification for important messages
if [ "$LEVEL" = "error" ] || [ "$LEVEL" = "warn" ]; then
  osascript -e "display notification \"$1\" with title \"Sili Terminal\" subtitle \"$LEVEL\""
fi
