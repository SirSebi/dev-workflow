# Architektur des dev-workflow Repos

Dieses Dokument beschreibt, **wie** das `dev-workflow` Repo aufgebaut ist und
warum. Es richtet sich an dich, wenn du den Workflow selbst weiterentwickelst —
nicht an die tägliche Projektarbeit (dafür: [CONTRIBUTING.md](../templates/CONTRIBUTING.md)).

## Grundidee

`dev-workflow` ist die **Single Source of Truth** für den Entwicklungsprozess
aller Projekte. Statt jedes Repo manuell zu konfigurieren, werden Templates,
Prompts und Konventionen zentral gepflegt und in die Projekt-Repos verteilt.

Es ist bewusst **kein** Anwendungs-Repo:

- Nur `main` — kein `develop`, keine Releases, keine Pakete.
- Inhalte sind ausschließlich Markdown, YAML und Shell.
- Versionierung über Git-Tags: `workflow-v1.0`, `workflow-v1.1`, …

## Verteilungsmodell

Templates werden **nicht** kopiert und eingecheckt, sondern zur Setup-Zeit
per `curl` von den `raw.githubusercontent.com`-URLs geladen:

```
dev-workflow (main)  ──curl──▶  Projekt-Repo (.github/, CONTRIBUTING.md, …)
```

Konsequenz: Das Repo muss öffentlich erreichbar sein, damit `curl` ohne
Authentifizierung funktioniert. Änderungen an Templates wirken sich erst bei
einem **erneuten Setup-Lauf** auf bestehende Projekte aus — es gibt keinen
automatischen Sync.

## Verzeichnisse

| Verzeichnis | Inhalt | Zielort im Projekt |
|-------------|--------|--------------------|
| `prompts/` | Claude-Code-Prompts für die einzelnen Workflow-Phasen | wird gelesen, nicht kopiert |
| `templates/github/ISSUE_TEMPLATE/` | Issue-Formulare (YAML) | `.github/ISSUE_TEMPLATE/` |
| `templates/github/workflows/` | GitHub Actions | `.github/workflows/` |
| `templates/github/PULL_REQUEST_TEMPLATE.md` | PR-Vorlage | `.github/` |
| `templates/CONTRIBUTING.md` | Mitwirkungs-Leitfaden | Repo-Root |
| `templates/workflow-config.example.yml` | Konfig-Vorlage | als `workflow-config.yml` im Repo-Root |
| `docs/` | Dokumentation des Workflows selbst | bleibt hier |

## Drei Bausteine

1. **Prompts** — steuern Claude Code durch Setup, Feature-Arbeit, Release und
   Hotfix. Sie sind die ausführbare Schicht: Befehle plus Erläuterung.
2. **Templates** — die statischen Artefakte, die in jedem Projekt landen und
   für Konsistenz sorgen (Labels, Issue-Felder, CI, Branch-Checks).
3. **Docs** — die erklärende Schicht: warum der Prozess so aussieht.

## Platzhalter-Konvention

Templates enthalten Platzhalter, die beim Setup ersetzt werden:

- `GITHUB_USER_PLACEHOLDER`, `CENTRAL_PROJECT_NUMBER_PLACEHOLDER` → via `sed`
  in `project-automation.yml`
- `$PROJECT_NAME`, `$GITHUB_REPO`, … → in Prompt `01` und `setup.sh`
- `DATUM_PLACEHOLDER` → aktuelles Datum in `workflow-config.yml`

## Abhängigkeiten

- **gh CLI** (authentifiziert) für Repo-/Label-/Project-Operationen.
- **PROJECT_TOKEN** (Secret, `repo` + `project` Scopes) für die Board-Automation
  in GitHub Actions — der Standard-`GITHUB_TOKEN` darf keine Org/User-Projects
  bearbeiten.
- **Zentrales Project Board** (Projects v2) als gemeinsames Ziel aller Repos.

## Weiterentwicklung

Änderungen am Workflow direkt auf `main` committen, dann taggen:

```bash
git commit -m "feat: …"
git tag -a workflow-v1.1 -m "…"
git push origin main --tags
```

Breaking Changes an Templates im Tag-Release dokumentieren, damit klar ist,
welche Projekte ein erneutes Setup brauchen.
