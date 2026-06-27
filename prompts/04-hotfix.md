# Claude Code – Hotfix
# Quelle: sirsebi/dev-workflow · prompts/04-hotfix.md

## VERWENDUNG

```
Lies https://raw.githubusercontent.com/sirsebi/dev-workflow/main/prompts/04-hotfix.md

GITHUB_REPO=sirsebi/mein-projekt
TICKET_NR=45
TICKET_BESCHREIBUNG=login-crash-fix
VERSION=v1.0.1
```

---

## AUFGABE

```bash
# 1. Von main branchen (nicht von develop!)
git checkout main && git pull origin main
git checkout -b hotfix/$TICKET_NR-$TICKET_BESCHREIBUNG

# 2. Fix entwickeln und committen
git add .
git commit -m "fix: $TICKET_BESCHREIBUNG (#$TICKET_NR)"
git push -u origin hotfix/$TICKET_NR-$TICKET_BESCHREIBUNG

# 3. PR gegen main
gh pr create \
  --repo $GITHUB_REPO \
  --base main \
  --title "hotfix: $TICKET_BESCHREIBUNG (#$TICKET_NR)" \
  --body "Closes #$TICKET_NR

**Hotfix** — geht direkt nach main, nicht über develop.

### Was wurde gefixt?
<!-- Beschreibung -->

### Wie wurde getestet?
<!-- Beschreibung -->"

# 4. Nach Merge: auch in develop zurückführen
git checkout develop && git pull origin develop
git merge main
git push origin develop

# 5. Patch-Release taggen
git checkout main && git pull origin main
git tag -a $VERSION -m "Hotfix $VERSION"
git push origin $VERSION
gh release create $VERSION --repo $GITHUB_REPO --title "Hotfix $VERSION" --generate-notes
```
