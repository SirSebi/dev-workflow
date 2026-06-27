# Claude Code – Release: develop → main
# Quelle: sirsebi/dev-workflow · prompts/03-release.md

## VERWENDUNG

```
Lies https://raw.githubusercontent.com/sirsebi/dev-workflow/main/prompts/03-release.md

GITHUB_REPO=sirsebi/mein-projekt
VERSION=v1.0.0
```

---

## AUFGABE

```bash
# 1. develop aktuell holen
git checkout develop && git pull origin develop

# 2. Alle geplanten Tickets für diesen Release prüfen
gh issue list --repo $GITHUB_REPO \
  --label "status: done" \
  --milestone "v1.0 MVP" \
  --json number,title | jq '.[] | "#\(.number) \(.title)"'

# 3. PR: develop → main
gh pr create \
  --repo $GITHUB_REPO \
  --base main \
  --head develop \
  --title "Release $VERSION" \
  --body "## Release $VERSION

### Enthaltene Änderungen
<!-- Aus den gemergten PRs zusammenstellen -->

### Abnahme-Checkliste
- [ ] Alle Tickets des Milestones auf 'Done'
- [ ] Keine offenen kritischen Bugs
- [ ] Build auf develop grün
- [ ] Manuelle Abnahme durch Sebastian durchgeführt"

# 4. Nach Abnahme und Merge: Release taggen
git checkout main && git pull origin main
git tag -a $VERSION -m "Release $VERSION"
git push origin $VERSION

# 5. GitHub Release erstellen
gh release create $VERSION \
  --repo $GITHUB_REPO \
  --title "Release $VERSION" \
  --generate-notes

echo "✅ Release $VERSION veröffentlicht"
```
