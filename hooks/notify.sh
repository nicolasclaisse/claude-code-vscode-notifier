#!/bin/bash

NOTIFIER="$HOME/Applications/ClaudeNotifier.app/Contents/MacOS/ClaudeNotifier"
MSG="Claude a terminé"

INPUT=$(cat)
TRANSCRIPT=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)

if [ -n "$TRANSCRIPT" ] && [ -f "$TRANSCRIPT" ]; then
  # Attendre que le transcript soit flush (max 3s)
  LINES_BEFORE=$(wc -l < "$TRANSCRIPT")
  for i in $(seq 1 6); do
    sleep 0.5
    LINES_NOW=$(wc -l < "$TRANSCRIPT")
    [ "$LINES_NOW" -gt "$LINES_BEFORE" ] && break
  done

  MSG=$(python3 - "$TRANSCRIPT" <<'EOF'
import sys, json

transcript_path = sys.argv[1]
last_text = ""

with open(transcript_path) as f:
    for line in f:
        try:
            obj = json.loads(line)
            msg = obj.get('message', {})
            if msg.get('role') != 'assistant':
                continue
            content = msg.get('content', [])
            texts = [c.get('text', '') for c in content if isinstance(c, dict) and c.get('type') == 'text' and c.get('text','').strip()]
            if texts:
                last_text = texts[0]
        except:
            pass

if not last_text:
    print("Claude a terminé")
    sys.exit()

last_text = last_text.strip()
safe = last_text.replace('"', "'")

if safe.rstrip().endswith('?'):
    print(f"Attends ton input - {safe[:80]}")
else:
    print(safe[:100])
EOF
  )
fi

"$NOTIFIER" "Claude Code" "$MSG" 2>/dev/null \
  || osascript -e "display notification \"$MSG\" with title \"Claude Code\" sound name \"Submarine\""
