# Security Policy

## Unterstutzte Versionen

Dieses Repository enthalt ESPHome-Konfigurationen und Helper-Code. Sicherheitsfixes werden auf dem Default-Branch umgesetzt.

## Meldung von Schwachstellen

Bitte melde Sicherheitsprobleme vertraulich und erstelle bei sensiblen Themen kein offentliches Issue.

1. Erstelle eine klare Beschreibung mit betroffenen Dateien, Reproduktionsschritten und Auswirkung.
2. Sende die Meldung uber einen privaten Kanal an den Maintainer.
3. Fuge nach Moglichkeit einen Fix- oder Mitigationsvorschlag hinzu.

Empfohlenes Meldeschema:

- Titel
- Betroffene Datei(en)
- Schweregrad (Critical/High/Medium/Low)
- Reproduktionsschritte
- Auswirkung
- Vorgeschlagene Behebung

## Sicherheits-Hinweise fur dieses Projekt

- Niemals echte Zugangsdaten in esphome/secrets.yaml committen.
- esphome/secrets.yaml nur lokal nutzen; als Vorlage dient esphome/secrets.example.yaml.
- Wenn esphome/secrets.yaml bereits in Git verfolgt wird, Datei einmalig aus dem Index entfernen: `git rm --cached esphome/secrets.yaml`.
- Externe Komponenten regelmassig vor Deployment prufen.
- ESPHome-Weboberflachen nicht direkt aus dem Internet erreichbar machen.
