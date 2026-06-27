# Claude Code – Workflow Setup
# Quelle: sirsebi/dev-workflow · prompts/01-workflow-setup.md

## PROJEKTKONFIGURATION

PROJECT_NAME=$PROJECT_NAME
GITHUB_REPO=$GITHUB_REPO
GITHUB_USER=$GITHUB_USER
PROJECT_TYPE=$PROJECT_TYPE          # java-spring | nextjs | fullstack
PROJECT_DESCRIPTION=$PROJECT_DESCRIPTION
CENTRAL_PROJECT_NUMBER=$CENTRAL_PROJECT_NUMBER
EPICS=$EPICS                        # Kommagetrennt, z.B. "v1.0 MVP,v1.1 Features"

---

## DEINE AUFGABE

Richte für das Projekt `$PROJECT_NAME` den vollständigen Entwicklungs-Workflow
ein. Du arbeitest im geklonten Repo `$GITHUB_REPO`.

Führe jeden Schritt aus, committe danach lokal, und push am Ende alles.
Melde dich nach jedem Schritt kurz mit ✅ oder ❌ + Grund.

---

## SCHRITT 0 — Orientierung

```bash
# Branches einlesen
git branch -a
git log --oneline -5 2>/dev/null || echo "Leeres Repo"

# Bestehende GitHub-Konfiguration prüfen
ls .github/ 2>/dev/null || echo ".github/ existiert noch nicht"
gh label list --repo $GITHUB_REPO 2>/dev/null | head -5 || true
```

Lies `workflow-config.yml` falls vorhanden — diese Datei enthält
projektspezifische Overrides die Vorrang vor den Defaults haben.

---

## SCHRITT 1 — Branch-Struktur

```bash
# Sicherstellen dass main existiert
git checkout main 2>/dev/null || (git checkout -b main && git push -u origin main)

# develop erstellen
git checkout develop 2>/dev/null || git checkout -b develop
git push -u origin develop 2>/dev/null || true
git checkout main
```

Branch Protection via GitHub CLI:

```bash
# main: PR required, kein Force-Push
gh api repos/$GITHUB_REPO/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":["build"]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false

# develop: PR required
gh api repos/$GITHUB_REPO/branches/develop/protection \
  --method PUT \
  --field required_status_checks='{"strict":false,"contexts":[]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews=null \
  --field restrictions=null \
  --field allow_force_pushes=false \
  --field allow_deletions=false
```

Erstelle `.github/BRANCH_NAMING.md`:

```markdown
# Branch-Naming-Konvention

Schema: `<typ>/<ticket-nr>-<kurze-beschreibung>`

Erlaubte Typen: feature, bugfix, hotfix, chore, refactor, docs, test

Beispiele:
- feature/23-auftragsformular-backend
- bugfix/31-datumvalidierung
- hotfix/44-login-crash
- chore/12-ci-einrichten
```

---

## SCHRITT 2 — Labels

Lösche alle Standard-Labels, erstelle das projektübergreifend konsistente Set:

```bash
gh label list --repo $GITHUB_REPO --json name --jq '.[].name' | \
  xargs -I {} gh label delete {} --repo $GITHUB_REPO --yes 2>/dev/null || true

# Typ
gh label create "type: epic"        --color "0075ca" --repo $GITHUB_REPO
gh label create "type: feature"     --color "0075ca" --repo $GITHUB_REPO
gh label create "type: bugfix"      --color "d73a4a" --repo $GITHUB_REPO
gh label create "type: hotfix"      --color "b60205" --repo $GITHUB_REPO
gh label create "type: chore"       --color "e4e669" --repo $GITHUB_REPO
gh label create "type: refactor"    --color "fbca04" --repo $GITHUB_REPO
gh label create "type: docs"        --color "0052cc" --repo $GITHUB_REPO
gh label create "type: test"        --color "006b75" --repo $GITHUB_REPO
gh label create "type: security"    --color "b60205" --repo $GITHUB_REPO

# Status
gh label create "status: backlog"     --color "ededed" --repo $GITHUB_REPO
gh label create "status: ready"       --color "c2e0c6" --repo $GITHUB_REPO
gh label create "status: in progress" --color "fef2c0" --repo $GITHUB_REPO
gh label create "status: in review"   --color "fbca04" --repo $GITHUB_REPO
gh label create "status: blocked"     --color "b60205" --repo $GITHUB_REPO
gh label create "status: done"        --color "0e8a16" --repo $GITHUB_REPO

# Priorität
gh label create "priority: critical" --color "b60205" --repo $GITHUB_REPO
gh label create "priority: high"     --color "d93f0b" --repo $GITHUB_REPO
gh label create "priority: medium"   --color "fbca04" --repo $GITHUB_REPO
gh label create "priority: low"      --color "c2e0c6" --repo $GITHUB_REPO

# Größe
gh label create "size: XS" --color "c2e0c6" --repo $GITHUB_REPO
gh label create "size: S"  --color "0e8a16" --repo $GITHUB_REPO
gh label create "size: M"  --color "fbca04" --repo $GITHUB_REPO
gh label create "size: L"  --color "d93f0b" --repo $GITHUB_REPO
gh label create "size: XL" --color "b60205" --repo $GITHUB_REPO

# Sonstiges
gh label create "needs: clarification" --color "d876e3" --repo $GITHUB_REPO
gh label create "needs: design"        --color "d876e3" --repo $GITHUB_REPO
gh label create "breaking change"      --color "b60205" --repo $GITHUB_REPO
```

---

## SCHRITT 3 — Zentrales Dashboard verknüpfen

Es gibt EIN zentrales GitHub Project Board für alle Projekte.
Dieses Repo wird damit verknüpft — kein neues Board anlegen.

```bash
# Repo mit dem zentralen Board verknüpfen
gh project link $CENTRAL_PROJECT_NUMBER \
  --owner $GITHUB_USER \
  --repo $GITHUB_REPO

echo "✅ Repo mit zentralem Board #$CENTRAL_PROJECT_NUMBER verknüpft"
```

Falls das Board noch nicht existiert (erstes Projekt):

```bash
# Nur beim allerersten Projekt ausführen
gh project create \
  --owner $GITHUB_USER \
  --title "Alle Projekte – Übersicht" \
  --format json | jq -r '.number'

# Danach: CENTRAL_PROJECT_NUMBER mit dieser Nummer in workflow-config.yml eintragen
```

---

## SCHRITT 4 — Issue Templates aus dev-workflow kopieren

```bash
mkdir -p .github/ISSUE_TEMPLATE

# Templates direkt aus dem dev-workflow Repo laden
WORKFLOW_RAW="https://raw.githubusercontent.com/sirsebi/dev-workflow/main"

curl -s "$WORKFLOW_RAW/templates/github/ISSUE_TEMPLATE/epic.yml"    > .github/ISSUE_TEMPLATE/epic.yml
curl -s "$WORKFLOW_RAW/templates/github/ISSUE_TEMPLATE/feature.yml" > .github/ISSUE_TEMPLATE/feature.yml
curl -s "$WORKFLOW_RAW/templates/github/ISSUE_TEMPLATE/bugfix.yml"  > .github/ISSUE_TEMPLATE/bugfix.yml
curl -s "$WORKFLOW_RAW/templates/github/ISSUE_TEMPLATE/chore.yml"   > .github/ISSUE_TEMPLATE/chore.yml
curl -s "$WORKFLOW_RAW/templates/github/ISSUE_TEMPLATE/config.yml"  > .github/ISSUE_TEMPLATE/config.yml

curl -s "$WORKFLOW_RAW/templates/github/PULL_REQUEST_TEMPLATE.md" > .github/PULL_REQUEST_TEMPLATE.md
curl -s "$WORKFLOW_RAW/templates/CONTRIBUTING.md" > CONTRIBUTING.md
```

---

## SCHRITT 5 — GitHub Actions kopieren

```bash
mkdir -p .github/workflows
WORKFLOW_RAW="https://raw.githubusercontent.com/sirsebi/dev-workflow/main"

# Board-Automation (funktioniert mit dem zentralen Board)
curl -s "$WORKFLOW_RAW/templates/github/workflows/project-automation.yml" \
  > .github/workflows/project-automation.yml

# Branch-Name-Validation
curl -s "$WORKFLOW_RAW/templates/github/workflows/branch-name-check.yml" \
  > .github/workflows/branch-name-check.yml

# CI — projektspezifisch
if [ "$PROJECT_TYPE" = "java-spring" ]; then
  curl -s "$WORKFLOW_RAW/templates/github/workflows/ci-java.yml" \
    > .github/workflows/ci.yml
elif [ "$PROJECT_TYPE" = "nextjs" ]; then
  curl -s "$WORKFLOW_RAW/templates/github/workflows/ci-nextjs.yml" \
    > .github/workflows/ci.yml
fi

# CENTRAL_PROJECT_NUMBER in project-automation.yml einsetzen
sed -i "s/CENTRAL_PROJECT_NUMBER_PLACEHOLDER/$CENTRAL_PROJECT_NUMBER/g" \
  .github/workflows/project-automation.yml
sed -i "s/GITHUB_USER_PLACEHOLDER/$GITHUB_USER/g" \
  .github/workflows/project-automation.yml
```

---

## SCHRITT 6 — Milestones

```bash
IFS=',' read -ra EPIC_LIST <<< "$EPICS"
for epic in "${EPIC_LIST[@]}"; do
  epic=$(echo "$epic" | xargs)
  gh api repos/$GITHUB_REPO/milestones \
    --method POST \
    --field title="$epic" \
    --field state="open" \
    --field description="Epic: $epic" 2>/dev/null || echo "Milestone existiert bereits: $epic"
done
```

---

## SCHRITT 7 — workflow-config.yml erstellen

Datei: `workflow-config.yml` im Projekt-Repo-Root

```yaml
# Workflow-Konfiguration
# Quelle: sirsebi/dev-workflow
# Erstellt: DATUM_PLACEHOLDER

workflow_version: "1.0"

project:
  name: "$PROJECT_NAME"
  type: "$PROJECT_TYPE"
  description: "$PROJECT_DESCRIPTION"
  repo: "$GITHUB_REPO"

central_board:
  owner: "$GITHUB_USER"
  project_number: $CENTRAL_PROJECT_NUMBER

branches:
  main: main
  develop: develop

build:
  dev_suffix: true
```

Ersetze `DATUM_PLACEHOLDER` mit dem aktuellen Datum.

---

## SCHRITT 8 — Alles committen und pushen

```bash
git add .
git commit -m "chore: vollständigen Entwicklungs-Workflow eingerichtet (dev-workflow v1.0)"
git push origin develop

echo ""
echo "=== SETUP ABGESCHLOSSEN ==="
echo "Repo:          $GITHUB_REPO"
echo "Branches:      main ← develop ← feature/*"
echo "Labels:        $(gh label list --repo $GITHUB_REPO --json name | jq length) Labels"
echo "Board:         #$CENTRAL_PROJECT_NUMBER (zentral, alle Projekte)"
echo ""
echo "WICHTIG — Manuell im GitHub UI:"
echo "1. Secret PROJECT_TOKEN im Repo hinterlegen (Settings → Secrets)"
echo "   Benötigt: repo + project Scopes"
echo "2. Ersten Epic als Issue anlegen (Template: Epic)"
echo "3. Tickets für Sprint 1 definieren und auf 'Ready' setzen"
```

---

## ABSCHLUSS-BERICHT

Gib mir nach dem Setup folgende Zusammenfassung:
- Welche Schritte ✅ erfolgreich / ❌ fehlgeschlagen (mit Grund)
- Ob das Repo bereits Dateien hatte die angepasst wurden
- Welche manuellen Schritte noch nötig sind (Secrets, Board-Felder etc.)
- Eventuelle Auffälligkeiten im bestehenden Code die ich kennen sollte
