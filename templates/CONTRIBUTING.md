# Entwicklungs-Workflow

Workflow-Quelle: [sirsebi/dev-workflow](https://github.com/sirsebi/dev-workflow)

## Branch-Strategie

```
main          ← Releases (getaggt, nach Abnahme)
  └── develop ← Integrationsstand, CI baut DEV-Artefakte
        ├── feature/NR-beschreibung
        ├── bugfix/NR-beschreibung
        └── hotfix/NR-beschreibung  ← geht direkt nach main!
```

## Ticket-Lifecycle

1. Epic anlegen → Tickets ableiten → Sprint planen
2. Ticket auf **Ready** setzen
3. Feature-Branch von `develop` erstellen: `feature/NR-kurztitel`
4. Entwickeln, atomar committen
5. Review-Checkliste im Ticket abhaken
6. PR gegen `develop` öffnen (Draft bis Checkliste fertig)
7. PR auf "Ready for Review" → Status automatisch "In Review"
8. Merge → Status automatisch "Done", Branch löschen
9. Sprint-Ende: develop → main, Release taggen

## Commit-Konvention

```
feat: beschreibung (#NR)
fix: beschreibung (#NR)
hotfix: beschreibung (#NR)
chore: beschreibung (#NR)
refactor: beschreibung (#NR)
docs: beschreibung (#NR)
test: beschreibung (#NR)
```

## Build-Verhalten

- `develop` → DEV-Artefakte (z.B. `app-1.0.0-DEV.jar`)
- `main` → Release-Artefakte (z.B. `app-1.0.0.jar`)
