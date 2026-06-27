# Branch-Strategie

Gilt für **alle** Anwendungs-Projekte (nicht für dieses Workflow-Repo, das nur
`main` führt).

## Überblick

```
main          ← Produktionsstand. Nur über PR, nach Abnahme, getaggt.
  └── develop ← Integrationsstand. CI baut DEV-Artefakte.
        ├── feature/NR-beschreibung
        ├── bugfix/NR-beschreibung
        ├── chore/NR-beschreibung
        └── hotfix/NR-beschreibung   ← Sonderfall, siehe unten
```

## Die zwei dauerhaften Branches

### `main`
- Spiegelt immer den zuletzt **abgenommenen** Release wider.
- Jeder Merge wird mit `vX.Y.Z` getaggt.
- Geschützt: PR erforderlich, 1 Review, Status-Check `build`, kein Force-Push,
  kein Löschen.

### `develop`
- Sammelstelle für fertige, gemergte Features.
- CI baut hier DEV-Artefakte (z.B. `app-1.0.0-DEV.jar`).
- Geschützt: PR erforderlich, kein Force-Push, kein Löschen.

## Kurzlebige Branches

Schema: `<typ>/<ticket-nr>-<kurze-beschreibung>`

| Typ | Basis | Ziel | Zweck |
|-----|-------|------|-------|
| `feature/` | `develop` | `develop` | Neue Funktionalität |
| `bugfix/` | `develop` | `develop` | Fehler im laufenden Stand |
| `chore/` | `develop` | `develop` | Infra, Deps, Refactoring |
| `refactor/`, `docs/`, `test/` | `develop` | `develop` | wie Name sagt |
| `hotfix/` | **`main`** | **`main`** (+ zurück nach `develop`) | Kritischer Produktionsfehler |

Regeln für den Namen (vom `branch-name-check` erzwungen):
`^(feature|bugfix|hotfix|chore|refactor|docs|test)/[0-9]+-[a-z0-9-]+$`

Beispiele:
- `feature/23-auftragsformular-backend`
- `bugfix/31-datumvalidierung`
- `hotfix/44-login-crash`

## Der Hotfix-Sonderfall

Ein Hotfix umgeht `develop`, weil er sofort in Produktion muss:

1. Branch von `main`.
2. Fix → PR gegen `main` → Merge → Patch-Tag (`v1.0.1`).
3. **Zwingend** zurück nach `develop` mergen, damit der Fix nicht beim
   nächsten Release verloren geht.

Details: [prompts/04-hotfix.md](../prompts/04-hotfix.md).

## Merge-Hygiene

- Feature-Branches vor dem PR auf `develop` aktualisieren (Rebase bevorzugt).
- Nach dem Merge den Branch löschen.
- Commits atomar halten, Message-Konvention siehe
  [CONTRIBUTING.md](../templates/CONTRIBUTING.md).
