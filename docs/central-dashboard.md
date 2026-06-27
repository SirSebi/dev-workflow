# Zentrales Dashboard

## Konzept

Ein GitHub Project Board für alle Projekte — kein Wechsel zwischen Boards.

GitHub Projects v2 unterstützt nativ das Verknüpfen mehrerer Repos
mit einem Board. Issues und PRs aus allen verknüpften Repos erscheinen
in einer Ansicht, filterbar nach Repository, Priorität, Sprint und Status.

## Board-URL

https://github.com/users/sirsebi/projects/3

## Board-Felder

| Feld | Typ | Optionen |
|------|-----|---------|
| Status | Single Select | 📋 Backlog, 🎯 Ready, 🔄 In Progress, 👀 In Review, ✅ Done, 🚫 Blocked |
| Priority | Single Select | 🔴 Critical, 🟠 High, 🟡 Medium, 🟢 Low |
| Size | Single Select | XS, S, M, L, XL |
| Sprint | Iteration | 2-Wochen-Zyklen |
| Repository | (automatisch) | Filterbar nach Projekt |

## Board-Ansichten

Folgende Views im Board anlegen:

1. **Alle Projekte** — kein Filter, alle Issues
2. **Aktiver Sprint** — Filter: Sprint = aktuell, Status ≠ Done
3. **Pro Projekt** — je eine gefilterte View per Repo
4. **Roadmap** — Roadmap-Ansicht nach Milestone

## Neues Projekt einbinden

```bash
gh project link 3 --owner sirsebi --repo sirsebi/neues-projekt
```

Danach erscheinen neue Issues des Repos automatisch im Board
(via project-automation.yml Action).

## Einschränkungen

- Labels sind repo-spezifisch (nicht board-weit) → deshalb
  einheitliches Label-Set in allen Repos (via Workflow-Setup sichergestellt)
- Milestones sind repo-spezifisch → im Board als Textfeld "Milestone" ergänzen
  falls eine übergreifende Roadmap nötig wird
