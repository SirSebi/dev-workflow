#!/usr/bin/env bash
# setup.sh — Einzeiler-Setup für ein neues Projekt
# Verwendung:
#   PROJECT_NAME=mein-projekt \
#   GITHUB_REPO=sirsebi/mein-projekt \
#   GITHUB_USER=sirsebi \
#   PROJECT_TYPE=java-spring \
#   PROJECT_DESCRIPTION="Kurze Beschreibung" \
#   CENTRAL_PROJECT_NUMBER=1 \
#   EPICS="v1.0 MVP,v1.1 Erweiterungen" \
#   bash <(curl -s https://raw.githubusercontent.com/sirsebi/dev-workflow/main/setup.sh)

set -e

# Pflichtfelder prüfen
: "${PROJECT_NAME:?PROJECT_NAME muss gesetzt sein}"
: "${GITHUB_REPO:?GITHUB_REPO muss gesetzt sein (format: user/repo)}"
: "${GITHUB_USER:?GITHUB_USER muss gesetzt sein}"
: "${PROJECT_TYPE:?PROJECT_TYPE muss gesetzt sein (java-spring|nextjs|fullstack)}"
: "${CENTRAL_PROJECT_NUMBER:?CENTRAL_PROJECT_NUMBER muss gesetzt sein}"

WORKFLOW_RAW="https://raw.githubusercontent.com/sirsebi/dev-workflow/main"

echo "=== dev-workflow Setup für: $PROJECT_NAME ==="
echo "Lade Workflow-Setup-Prompt..."

PROMPT=$(curl -s "$WORKFLOW_RAW/prompts/01-workflow-setup.md")

echo "$PROMPT" | \
  sed "s/\$PROJECT_NAME/$PROJECT_NAME/g" | \
  sed "s|\$GITHUB_REPO|$GITHUB_REPO|g" | \
  sed "s/\$GITHUB_USER/$GITHUB_USER/g" | \
  sed "s/\$PROJECT_TYPE/$PROJECT_TYPE/g" | \
  sed "s/\$CENTRAL_PROJECT_NUMBER/$CENTRAL_PROJECT_NUMBER/g" | \
  sed "s/\$EPICS/$EPICS/g" \
  > /tmp/workflow-setup-resolved.md

echo "✅ Prompt generiert: /tmp/workflow-setup-resolved.md"
echo ""
echo "Nächster Schritt: Claude Code mit diesem Prompt starten:"
echo "  claude < /tmp/workflow-setup-resolved.md"
