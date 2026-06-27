## 🔗 Referenz

Closes #<!-- Issue-Nummer -->
Epic: #<!-- Epic-Nummer, falls zutreffend -->

---

## 📋 Zusammenfassung

<!-- Was wurde geändert und warum? 2–4 Sätze. -->

---

## 🔧 Art der Änderung

- [ ] ✨ Feature
- [ ] 🐛 Bugfix
- [ ] 🔥 Hotfix
- [ ] 🔧 Chore / Refactoring
- [ ] 📚 Docs
- [ ] ⚡ Performance
- [ ] 🔒 Security

---

## 🔍 Review-Checkliste

### Code
- [ ] Kompiliert fehlerfrei
- [ ] Kein auskommentierter Code / Debug-Ausgaben
- [ ] Kein hardcodierter Wert der in Config/Env gehört
- [ ] Keine sensitiven Daten (Passwörter, Keys, Tokens)
- [ ] Imports aufgeräumt

### Funktionalität
- [ ] Alle Akzeptanzkriterien aus dem Ticket erfüllt
- [ ] Fehlerbehandlung vollständig
- [ ] Logging sinnvoll
- [ ] Edge Cases berücksichtigt

### Tests
- [ ] Unit Tests für neue Logik vorhanden
- [ ] Alle bestehenden Tests grün
- [ ] Integrationstests angepasst falls nötig

### Branch & Commits
- [ ] Branch-Name: `feature/NR-beschreibung`
- [ ] Commits atomar mit sinnvollen Messages
- [ ] Branch aktuell mit `develop` (rebase bevorzugt)

---

## 📸 Screenshots (bei UI-Änderungen)

<!-- Vorher / Nachher -->

---

## 🧪 Testanweisungen

```
1. git checkout feature/NR-beschreibung
2. ...
3. Erwartet: ...
```

---

## ⚠️ Breaking Changes

- [ ] Ja → Details:
- [ ] Nein
