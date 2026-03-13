#!/bin/bash
# Check tmux env var directly — works even when #{$VAR} expansion is broken
enabled=$(tmux showenv -g TMUX_SHOW_CLAUDE 2>/dev/null | cut -d= -f2)
[ "$enabled" = "1" ] || exit 0

CACHE="$HOME/.claude/.status-cache"
CACHE_AGE=900  # only hit API every 15 minutes
if [ -f "$CACHE" ] && [ $(( $(date +%s) - $(stat -c %Y "$CACHE") )) -lt $CACHE_AGE ]; then
  cat "$CACHE"
  exit 0
fi

CREDS="$HOME/.claude/.credentials.json"
TOKEN=$(jq -r '.claudeAiOauth.accessToken' "$CREDS" 2>/dev/null)
[ -z "$TOKEN" ] && echo " 🤖 5h:? 7d:?" && exit 0

DATA=$(curl -s --max-time 5 "https://api.anthropic.com/api/oauth/usage" \
  -H "Authorization: Bearer $TOKEN" \
  -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)

if echo "$DATA" | grep -q "rate_limit_error"; then
  [ -f "$CACHE" ] && cat "$CACHE" || echo " 🤖 5h:? 7d:?"
  exit 0
fi

FIVE=$(echo "$DATA" | jq -r '.five_hour.utilization // "?"' 2>/dev/null)
SEVEN=$(echo "$DATA" | jq -r '.seven_day.utilization // "?"' 2>/dev/null)
RESET=$(echo "$DATA" | jq -r '.five_hour.resets_at // ""' | xargs -I{} date -d {} +"%H:%M" 2>/dev/null)

RESULT=" 🤖 5h:${FIVE}% 7d:${SEVEN}% ↺${RESET} "
echo "$RESULT" > "$CACHE"
echo "$RESULT"
