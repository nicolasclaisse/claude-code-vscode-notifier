#!/bin/bash

NOTIFIER="$HOME/Applications/ClaudeNotifier.app/Contents/MacOS/ClaudeNotifier"
MSG="Claude a terminé"

INPUT=$(cat)

# Extraire transcript_path depuis le JSON stdin
TRANSCRIPT=$(echo "$INPUT" | sed -n 's/.*"transcript_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p')

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Attendre que le transcript soit flush (max 3s)
  LINES_BEFORE=$(wc -l < "$TRANSCRIPT")
  for i in $(seq 1 6); do
    sleep 0.5
    LINES_NOW=$(wc -l < "$TRANSCRIPT")
    [ "$LINES_NOW" -gt "$LINES_BEFORE" ] && break
  done

  # Extraire le dernier message texte de l'assistant
  LAST_TEXT=$(grep '"role"[[:space:]]*:[[:space:]]*"assistant"' "$TRANSCRIPT" \
    | grep -o '"type"[[:space:]]*:[[:space:]]*"text"[[:space:]]*,[[:space:]]*"text"[[:space:]]*:[[:space:]]*"[^"]*"' \
    | sed 's/.*"text"[[:space:]]*:[[:space:]]*"//;s/"$//' \
    | tail -1)

  if [ -n "$LAST_TEXT" ]; then
    if [[ "$LAST_TEXT" =~ \?[[:space:]]*$ ]]; then
      MSG="Attends ton input - ${LAST_TEXT:0:80}"
    else
      MSG="${LAST_TEXT:0:100}"
    fi
  fi
fi

"$NOTIFIER" "Claude Code" "$MSG" 2>/dev/null \
  || osascript -e "display notification \"$MSG\" with title \"Claude Code\" sound name \"Submarine\""
