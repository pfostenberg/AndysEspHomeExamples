# Changelog

Alle wichtigen Anderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an Keep a Changelog, und dieses Projekt folgt Semantic Versioning.

## [Unreleased]

### Added
- .env.example mit optionalen Entwicklungs-Umgebungsvariablen hinzugefugt.
- SECURITY.md mit Hinweisen fur verantwortungsvolle Meldung von Sicherheitsproblemen hinzugefugt.
- esphome/secrets.example.yaml als sicheres Secrets-Template hinzugefugt.

### Changed
- README.md mit vollstandiger Dokumentation fur Setup, Installation, Konfiguration, Nutzung und Workflow aktualisiert.
- README.md, CHANGELOG.md, SECURITY.md und esphome/readme_esphome.md auf Deutsch als Hauptsprache vereinheitlicht.
- Helper-Header in PowMr auf explizite String-Abhangigkeit und const-Referenz-Signaturen umgestellt.
- Externe Seplos-Component-Referenz in pip5048_seplos.yaml uber Substitution konfigurierbar gemacht (einfaches Pinning auf Tag/Commit).
- README.md und SECURITY.md um den Untrack-Hinweis fur bereits eingecheckte Secrets-Dateien erweitert.
- verify_ssl in mehreren ESPHome-Configs auf konfigurierbare Substitutionen umgestellt (gleiches Default-Verhalten, zentral einfacher hartbar).

### Fixed
- Moglichen Divide-by-zero-Fall in der PowMr-Berechnung fur den Leistungsfaktor behoben.
- Parsing in myHelpers.cpp gegen ungultige String-Konvertierungen gehartert.
- Null-Pointer-Guard in der Helper-Funktion fur Select-Updates hinzugefugt.
- Secrets-Ignore-Regel in .gitignore wieder aktiviert.

### Removed
- Ungenutzte C++-Includes in den Helper-Quelldateien entfernt.

### Security
- Risiko fur versehentliches Offenlegen von Secrets durch dokumentierte lokale Secrets-Nutzung und aktive Ignore-Regel reduziert.

### Breaking Changes
- Keine.
