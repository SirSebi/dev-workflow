# Ticket-Lifecycle

Wie ein Stück Arbeit von der Idee bis zum Release durch das System wandert.
Der Status wird über **Labels** geführt; die Board-Automation
(`project-automation.yml`) hält sie an den richtigen Stellen automatisch nach.

## Status-Verlauf

```
backlog → ready → in progress → in review → done
                      ↑↓
                   blocked
```

| Status-Label | Bedeutung | Wer/was setzt es |
|--------------|-----------|------------------|
| `status: backlog` | Erfasst, noch nicht eingeplant | Issue-Template (Default) |
| `status: ready` | Eingeplant, bereit zur Umsetzung | manuell bei Sprint-Planung |
| `status: in progress` | In Arbeit | Automation, wenn PR geöffnet wird |
| `status: in review` | PR steht zur Review | Automation, wenn PR „Ready for review" |
| `status: blocked` | Wartet auf etwas anderes | manuell |
| `status: done` | Gemerged, erledigt | Automation, wenn PR gemerged |

## Lebenszyklus Schritt für Schritt

1. **Erfassen** — Issue über ein Template anlegen (Epic, Feature, Bugfix,
   Chore). Pflichtfelder erzwingen Klarheit über Ziel, Akzeptanzkriterien und
   Größe. Landet automatisch im zentralen Board.
2. **Verfeinern** — Priorität, Größe und ggf. Epic-Zuordnung setzen. Offene
   Fragen mit `needs: clarification` / `needs: design` markieren.
3. **Einplanen** — im Sprint auf `status: ready` setzen.
4. **Umsetzen** — Branch von `develop` (`feature/NR-…`). Beim Öffnen des PR
   springt der Status automatisch auf `in progress`.
5. **Review** — Review-Checkliste im PR-Template abhaken, PR von Draft auf
   „Ready for review" → Status `in review`.
6. **Abschließen** — Merge nach `develop`. Status → `done`, Branch löschen.
   Das `Closes #NR` im PR-Body schließt das Issue.
7. **Ausliefern** — beim Release (`develop → main`) wird das Ticket Teil eines
   getaggten Releases.

## Verknüpfung PR ↔ Issue

Die Automation findet das zugehörige Issue über `Closes #NR` im **PR-Body**.
Ohne diese Zeile werden keine Status-Labels umgesetzt — daher ist sie Pflicht.

## Epics

Epics bündeln mehrere Tickets unter einem gemeinsamen Ziel und Milestone. Sie
durchlaufen denselben Status-Fluss, werden aber nicht über einen einzelnen PR
„done", sondern wenn alle enthaltenen Tickets erledigt sind.

## Größen-Konvention

| Label | Aufwand |
|-------|---------|
| `size: XS` | < 2 Stunden |
| `size: S` | 2–4 Stunden |
| `size: M` | halber bis ganzer Tag |
| `size: L` | 1–3 Tage |
| `size: XL` | > 3 Tage → möglichst aufteilen |
