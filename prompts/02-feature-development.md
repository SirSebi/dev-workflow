# Claude Code – Feature entwickeln
# Quelle: sirsebi/dev-workflow · prompts/02-feature-development.md

## VERWENDUNG

Diesen Prompt nutzen wenn ein Ticket aus dem Board auf "Ready" steht
und mit der Entwicklung begonnen werden soll.

```
Lies https://raw.githubusercontent.com/sirsebi/dev-workflow/main/prompts/02-feature-development.md

Ticket: #NR — Kurztitel
Branch: feature/NR-kurztitel
```

---

## AUFGABE

```bash
# Schritt 1: Aktuellen Stand holen
git checkout develop
git pull origin develop

# Schritt 2: Feature-Branch erstellen
BRANCH="feature/TICKET_NR-TICKET_BESCHREIBUNG"
git checkout -b $BRANCH

# Schritt 3: Ticket-Status setzen
gh issue edit TICKET_NR --repo GITHUB_REPO \
  --add-label "status: in progress" \
  --remove-label "status: ready"
```

Entwickle das Feature anhand der Ticket-Beschreibung und Akzeptanzkriterien.

Nach Fertigstellung:

```bash
# Review-Checkliste im Ticket durchgehen (manuell abhaken)
# Dann PR öffnen:

git add .
git commit -m "feat: kurze Beschreibung (#TICKET_NR)"
git push -u origin $BRANCH

gh pr create \
  --repo GITHUB_REPO \
  --base develop \
  --title "feat: kurze Beschreibung (#TICKET_NR)" \
  --body "Closes #TICKET_NR" \
  --draft  # Als Draft bis Review-Checkliste vollständig ausgefüllt
```

Öffne den PR als Draft. Sobald alle Checklisten-Punkte im PR-Template
ausgefüllt sind: "Ready for review" klicken — das triggert die Board-Automation.
