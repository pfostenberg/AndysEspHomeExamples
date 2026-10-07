# Changelog

Alle wichtigen Anderungen an diesem Projekt werden in dieser Datei dokumentiert.

Das Format orientiert sich an Keep a Changelog, und dieses Projekt folgt Semantic Versioning.

## [Unreleased]

### Added
- [scripts/build-powmr1.ps1](scripts/build-powmr1.ps1) fur [esphome/powmr1.yaml](esphome/powmr1.yaml) mit `compile`, `validate`, `upload`, `ota`, `logs`, `run` und `help` hinzugefugt. Standard ist Kompilieren ohne Flashen; Konfigurations- und venv-Pfade sind unabhangig vom Terminalordner, ESPHome-Fehler werden als Exit-Code weitergegeben.
- .env.example mit optionalen Entwicklungs-Umgebungsvariablen hinzugefugt.
- SECURITY.md mit Hinweisen fur verantwortungsvolle Meldung von Sicherheitsproblemen hinzugefugt.
- esphome/secrets.example.yaml als sicheres Secrets-Template hinzugefugt.

### Changed
- Zellspannungen in [hagen/esphome/pipseplos01.yaml](hagen/esphome/pipseplos01.yaml) wieder in Millivolt ausgegeben. Die Seplos-Komponente liefert Volt; alle 48 Zellsensoren (16 Zellen x 3 Packs) nutzen jetzt den YAML-Anker `v_to_mv` mit `multiply: 1000`, damit ioBroker die gewohnten Werte erhalt.
- [README.md](README.md) und [HOWTO.md](HOWTO.md) um PowMr-Build-Befehle, Gerateauswahl und Hinweise zu relativen YAML-Abhangigkeiten erweitert. Den bei der Validierung festgestellten fehlenden Include-Pfad der Root-Konfiguration in der README dokumentiert.
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
