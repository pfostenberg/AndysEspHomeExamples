# AndysEspHomeExamples

ESPHome-Konfigurationsbeispiele fur Solarwechselrichter, Batteriesysteme und programmierbare Netzteile.

Dieses Repository bietet praxisnahe YAML-Konfigurationen und Helper-Code, um Telemetriedaten zu lesen, Gerate uber Modbus/UART zu steuern und Daten per MQTT oder uber ESPHome-Web-Entitaten bereitzustellen.

### Projektziel

- Funktionierende ESPHome-Beispiele fur reale Hardware-Setups bereitstellen.
- Bewahrte Register-Mappings und Steuerungs-Entitaten dokumentieren.
- Modulare YAML-Includes fur bessere Wartbarkeit wiederverwenden.

### Repository-Struktur

- esphome/: Hauptkonfigurationen fur ESPHome-Gerate.
- esphome/PowMr/: PowMr-Inverter-Profil, Includes und C++-Helper.
- esphome/PowMr/src/: Modularisierte PowMr-Variante (main.yaml + Module).
- esphome/readme_esphome.md: Zusatzhinweise fur einzelne Gerate.
- [scripts/build-powmr1.ps1](scripts/build-powmr1.ps1): PowerShell-Build-Script fur [esphome/powmr1.yaml](esphome/powmr1.yaml).

### Voraussetzungen

- Python 3.10+ empfohlen
- ESPHome CLI
- Unterstutzte ESP-Boards (z. B. ESP32-S3 und ESP8266/D1 Mini)
- MQTT-Broker (optional, in den meisten Beispielen verwendet)

### Installation

1. Python-Umgebung (venv) erstellen und aktivieren.
2. ESPHome installieren:

```bash
python -m pip install esphome
```

3. Repository klonen und in das Verzeichnis wechseln.

### Einrichtung

1. Secrets-Template kopieren:

```bash
cp esphome/secrets.example.yaml esphome/secrets.yaml
```

2. esphome/secrets.yaml mit lokalen Zugangsdaten befullen.
3. esphome/secrets.yaml privat halten (bewusst in .gitignore vorgesehen).
4. Falls die Datei bereits einmal eingecheckt wurde, einmalig aus dem Git-Index entfernen:

```bash
git rm --cached esphome/secrets.yaml
```

### Konfiguration

Wichtige Dateien:

- esphome/pip5048_seplos.yaml
- esphome/wanptek_d1mini32.yaml
- esphome/LumiaxMC6015.yaml
- esphome/PowMr/powmr1.yaml
- esphome/PowMr/src/main.yaml (modularisierte Variante)

Mindestens anpassen:

- WLAN- und MQTT-Zugangsdaten uber !secret-Referenzen.
- UART-Pins und Baudraten entsprechend der Verdrahtung.
- Modbus-Adressen der Gerate.
- Update-Intervalle passend zu Last und Performance.

### Verwendung

#### PowMr mit PowerShell

Das [Build-Script](scripts/build-powmr1.ps1) verwendet
[esphome/powmr1.yaml](esphome/powmr1.yaml). Es findet ESPHome in `scripts/.venv`,
alternativ in `.venv` oder im PATH. Die Konfiguration wird unabhangig vom
aktuellen Terminalordner gefunden.

Aus dem Repository-Verzeichnis:

```powershell
.\scripts\build-powmr1.ps1 validate
.\scripts\build-powmr1.ps1 compile
.\scripts\build-powmr1.ps1 upload -Device COM3
.\scripts\build-powmr1.ps1 ota -Device 192.168.77.13
.\scripts\build-powmr1.ps1 logs -Device 192.168.77.13
.\scripts\build-powmr1.ps1 run -Device COM3
.\scripts\build-powmr1.ps1 help
```

Ohne Befehl wird nur kompiliert. `upload` und `ota` kompilieren vor dem Flashen.
Ohne `-Device` verwendet `ota` den Hostnamen `powmr1.local`; bei `upload`, `logs`
und `run` ubernimmt ESPHome die Gerateauswahl. Fehler werden als Exit-Code
weitergegeben. Weitere Setup-Hinweise stehen in [HOWTO.md](HOWTO.md).

Aktueller Konfigurations-Blocker: Die YAML referenziert
`includes/common_sensors.yaml`, das relativ zu ihrem Speicherort fehlt.
Die vorhandene Datei liegt unter
[esphome/PowMr/includes/common_sensors.yaml](esphome/PowMr/includes/common_sensors.yaml).
Vor dem Build mussen die relativen `!include`- und `includes`-Pfade in der YAML
zu den vorhandenen Dateien passen.

#### Direkte ESPHome-Aufrufe

Konfiguration validieren:

```bash
python -m esphome config esphome/PowMr/powmr1.yaml
```

Flashen oder ausfuhren:

```bash
python -m esphome run esphome/PowMr/powmr1.yaml
```

Logs anzeigen:

```bash
python -m esphome logs esphome/PowMr/powmr1.yaml
```

### Wichtige Hinweise

- YAML-Dateien vor Deployment immer validieren.
- Konfigurationen vor Rollout kompilieren und auf Hardware testen.
- ESPHome-Logs zur Plausibilitatsprufung von Registerwerten nutzen.

### Entwicklungsablauf

1. Device-YAML erstellen oder anpassen.
2. Mit esphome config validieren.
3. Auf Hardware mit esphome run und esphome logs testen.
4. MQTT-Topics und Home-Assistant-Entitaten prufen.
5. Register- und Verdrahtungsbesonderheiten dokumentieren.

### Sicherheit

- Niemals echte Secrets oder Zugangsdaten committen.
- ESPHome-Weboberflachen nicht direkt aus offentlichen Netzen erreichbar machen.
- Einige Beispiele verwenden http_request.verify_ssl: false; wo moglich TLS-Prufung aktivieren.
- Externe Komponenten regelmassig prufen, besonders bei Quellen mit @main.

Weitere Hinweise stehen in SECURITY.md.

### Bekannte Besonderheiten

- Protokolle und Register konnen je nach Firmwarestand variieren.
- Einige Beispiele sind bewusst diagnostiklastig und mussen fur Produktion ggf. entschlackt werden.
- Zwei BLE-Include-Dateien sind in UTF-16 kodiert; bei Bedarf in UTF-8 konvertieren.

### Lizenz

Lizenziert unter Apache-2.0. Siehe LICENSE.