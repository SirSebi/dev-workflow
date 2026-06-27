# dev-workflow

Single Source of Truth für den Entwicklungs-Workflow aller Projekte.

Dieses Repo enthält Templates, Prompts und Dokumentation um jedes Projekt
konsistent aufzusetzen und zu pflegen.

## Enthaltene Prompts

| Prompt | Verwendung |
|--------|-----------|
| [01-workflow-setup.md](prompts/01-workflow-setup.md) | Neues Projekt einrichten oder bestehendes Projekt nachträglich mit Workflow ausstatten |
| [02-feature-development.md](prompts/02-feature-development.md) | Tägliche Arbeit: Feature-Branch erstellen, entwickeln, PR öffnen |
| [03-release.md](prompts/03-release.md) | Sprint abschließen: develop → main mergen, Release taggen |
| [04-hotfix.md](prompts/04-hotfix.md) | Kritischen Fehler in Produktion beheben |

## Schnellstart: Neues Projekt aufsetzen

Claude Code starten, dann:

```
Lies https://raw.githubusercontent.com/sirsebi/dev-workflow/main/prompts/01-workflow-setup.md

Projektkonfiguration:
  PROJECT_NAME=mein-projekt
  GITHUB_REPO=sirsebi/mein-projekt
  GITHUB_USER=sirsebi
  PROJECT_TYPE=java-spring
  PROJECT_DESCRIPTION=Kurze Beschreibung was das Projekt macht
  CENTRAL_PROJECT_NUMBER=1
  EPICS=v1.0 MVP,v1.1 Erweiterungen
```

## Zentrales Dashboard

Alle Projekte laufen in **einem** GitHub Project Board zusammen:
→ https://github.com/users/sirsebi/projects/1

Jedes neue Projekt-Repo wird mit diesem Board verknüpft. Issues und PRs
aller Projekte erscheinen in einer einzigen Board-Ansicht, filterbar nach
Repository, Priorität, Sprint und Status.

Details: [docs/central-dashboard.md](docs/central-dashboard.md)

## Branch-Strategie (alle Projekte)

```
main          ← Releases, nach Abnahme gemerged, getaggt
  └── develop ← Integrationsstand, CI baut DEV-Artefakte
        └── feature/NR-beschreibung
        └── bugfix/NR-beschreibung
        └── hotfix/NR-beschreibung
```

## Repo-Konvention

Dieses Repo hat nur `main`. Änderungen direkt committen.
Versionierung über Git-Tags: `workflow-v1.0`, `workflow-v1.1`, etc.
