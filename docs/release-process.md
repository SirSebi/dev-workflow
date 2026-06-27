# Release-Prozess

Wie ein Integrationsstand auf `develop` zu einem abgenommenen, getaggten
Release auf `main` wird. Der ausführbare Ablauf steht in
[prompts/03-release.md](../prompts/03-release.md); dieses Dokument erklärt das
Drumherum.

## Versionsschema

Semantische Versionierung: `vMAJOR.MINOR.PATCH`

- **MAJOR** — Breaking Changes.
- **MINOR** — neue, abwärtskompatible Features (regulärer Sprint-Release).
- **PATCH** — Hotfixes (siehe [prompts/04-hotfix.md](../prompts/04-hotfix.md)).

Tags werden auf `main` gesetzt: `git tag -a v1.2.0 -m "Release v1.2.0"`.

## Regulärer Release (develop → main)

1. **`develop` einfrieren** — keine neuen Features mehr für diesen Release.
2. **Vollständigkeit prüfen** — alle Tickets des Milestones auf
   `status: done`, keine offenen kritischen Bugs, CI auf `develop` grün.
3. **Release-PR** `develop → main` öffnen mit Abnahme-Checkliste.
4. **Abnahme** durch Sebastian (manueller Funktionstest).
5. **Merge** nach `main`.
6. **Taggen** und **GitHub Release** mit automatisch generierten Notes
   (`gh release create … --generate-notes`).

## Abnahme-Checkliste

- [ ] Alle Tickets des Milestones auf `status: done`
- [ ] Keine offenen Issues mit `priority: critical`
- [ ] Build auf `develop` grün
- [ ] Manuelle Abnahme durchgeführt

## Build-Artefakte

| Branch | Artefakt | Beispiel |
|--------|----------|----------|
| `develop` | DEV-Build (Suffix) | `app-1.2.0-DEV.jar` |
| `main` | Release-Build | `app-1.2.0.jar` |

Das `-DEV`-Suffix (gesteuert über `build.dev_suffix` in `workflow-config.yml`)
macht jederzeit sichtbar, ob ein Artefakt vom Integrations- oder vom
Release-Stand stammt.

## Hotfix-Releases

Hotfixes erzeugen PATCH-Releases direkt von `main` und werden anschließend nach
`develop` zurückgeführt, damit der nächste reguläre Release den Fix enthält.
Vollständiger Ablauf: [prompts/04-hotfix.md](../prompts/04-hotfix.md).

## Nach dem Release

- Milestone schließen.
- Neuen Milestone für den nächsten Sprint anlegen.
- Release Notes kurz prüfen und ggf. um Kontext ergänzen.
