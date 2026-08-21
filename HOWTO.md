# HOWTO: ESPHome auf einem ESP32/ESP8266 installieren und in Betrieb nehmen

Komplette Schritt-für-Schritt-Anleitung – vom leeren ESP-Board bis zur laufenden Konfiguration.

---

**Auch verfügbar:**
- [SOLDERING.md](SOLDERING.md) – Lötanleitung für die self-developed Interfaceplatin
- [README.md](README.md) – Repository-Übersicht

---

## Quick Start mit Setup-Scripts (empfohlen)

Falls du Windows oder Linux/macOS nutzt, können die vorbereiteten Setup-Scripts Python-Environment und ESPHome automatisch einrichten:

### Windows (PowerShell)
```powershell
cd AndysEspHomeExamples
.scripts\setup-esphome.ps1
```

### Linux / macOS
```bash
cd AndysEspHomeExamples
bash scripts/setup-esphome.sh
```

Das Script macht folgende Schritte automatisch:
- ✓ Prüft Python 3.10+
- ✓ Erstellt venv (falls nicht vorhanden)
- ✓ Aktiviert venv
- ✓ Installiert ESPHome

Nach erfolgreichem Script-Ablauf: Gehe direkt zu **Abschnitt 5 (Secrets einrichten)**.

---

## Manuelle Installation (Alternative)

Falls du die Scripts nicht verwenden möchtest oder auf einer anderen Platform arbeitest:

### 1. Voraussetzungen

### Software

- Python 3.10 oder neuer ([python.org](https://www.python.org/downloads/))
- Git (optional, zum Klonen des Repos)
- USB-Treiber für dein Board:
  - ESP32-S3: meist ohne extra Treiber (USB-CDC)
  - ESP32 (klassisch) / D1 Mini: CP2102 oder CH340 Treiber
- Ein Terminalemulator (PowerShell, Bash, etc.)

### Hardware

- ESP32-S3, ESP32 oder ESP8266 (D1 Mini) Board
- USB-Kabel (Daten, kein reines Ladekabel!)
- Ggf. RS485-Adapter (z. B. Waveshare TTL-zu-RS485) je nach Gerät

---

### 2. Python-Umgebung einrichten

```bash
# Virtuelles Environment erstellen
python -m venv .venv

# Aktivieren (Windows PowerShell)
.venv\Scripts\Activate.ps1

# Aktivieren (Linux/macOS)
source .venv/bin/activate
```

---

### 3. ESPHome installieren

```bash
python -m pip install esphome
```

Prüfen ob es funktioniert:

```bash
python -m esphome version
```

---

### 4. Repository klonen

```bash
git clone https://github.com/<user>/AndysEspHomeExamples.git
cd AndysEspHomeExamples
```

---

## 5. Secrets einrichten

Die Secrets-Datei enthält WLAN-Passwörter, MQTT-Zugangsdaten usw. und darf **nie** ins Git eingecheckt werden.

```bash
cp esphome/secrets.example.yaml esphome/secrets.yaml
```

Dann `esphome/secrets.yaml` mit einem Editor öffnen und die Platzhalter durch echte Werte ersetzen:

| Key               | Beschreibung                              |
| ----------------- | ----------------------------------------- |
| `wifi_ssid`       | Dein WLAN-Name                            |
| `wifi_password`   | Dein WLAN-Passwort                        |
| `mqtt_host`       | IP-Adresse des MQTT-Brokers               |
| `mqtt_username`   | MQTT-Benutzername                         |
| `mqtt_password`   | MQTT-Passwort                             |
| `encryption_key`  | Home-Assistant-API-Encryption-Key         |
| `ap_password`     | Fallback-Hotspot-Passwort                 |
| `ota_password`    | Passwort für Over-the-Air-Updates         |

---

## 6. YAML-Konfiguration wählen und anpassen

Wähle die passende Konfigurationsdatei für dein Setup:

| Datei                              | Gerät / Zweck                             |
| ---------------------------------- | ----------------------------------------- |
| `esphome/PowMr/powmr1.yaml`       | PowMr Hybrid-Wechselrichter (ESP32-S3)   |
| `esphome/PowMr/src/main.yaml`     | PowMr modularisierte Variante            |
| `esphome/wanptek_d1mini32.yaml`   | Wanptek KPS6050D Netzteil (ESP32 D1 Mini) |
| `esphome/pip5048_seplos.yaml`     | PIP5048 + Seplos BMS                      |
| `esphome/LumiaxMC6015.yaml`       | Lumiax MC6015 Laderegler                  |

### Mindestens prüfen/anpassen:

- **UART-Pins** (`tx_pin`, `rx_pin`) – müssen zur Verdrahtung passen
- **Board-Typ** (`esp32:` → `board:`) – muss dem tatsächlichen Board entsprechen
- **Modbus-Adresse** – muss zur Geräteeinstellung passen
- **Update-Intervalle** – je nach gewünschter Abfragefrequenz

---

## 7. Konfiguration validieren

Bevor geflasht wird, immer erst prüfen ob die YAML fehlerfrei ist:

```bash
python -m esphome config esphome/PowMr/powmr1.yaml
```

Bei Erfolg wird die aufgelöste Konfiguration angezeigt. Fehler werden mit Zeilennummer ausgegeben.

---

## 8. Erstmaliges Flashen über USB

Beim **ersten Mal** muss der ESP per USB verbunden und geflasht werden:

```bash
python -m esphome run esphome/PowMr/powmr1.yaml
```

### Was passiert:

1. ESPHome kompiliert die Firmware (dauert beim ersten Mal 1–3 Minuten).
2. Du wirst nach dem Upload-Port gefragt – wähle den USB-Port (z. B. `COM3` unter Windows oder `/dev/ttyUSB0` unter Linux).
3. Die Firmware wird geflasht.
4. Der ESP startet neu und verbindet sich mit dem WLAN.
5. Die Logs werden direkt angezeigt.

### Häufiges Problem: Port wird nicht erkannt

- USB-Kabel tauschen (Datenkabel verwenden!)
- Treiber installieren (CP2102 / CH340)
- Unter Windows: Geräte-Manager → COM-Ports prüfen
- ESP32-S3: Boot-Taste gedrückt halten beim Einstecken

---

## 9. Over-the-Air Updates (nach Erstinstallation)

Nach dem ersten Flash verbindet sich der ESP mit dem WLAN. Ab dann können Updates kabellos erfolgen:

```bash
python -m esphome run esphome/PowMr/powmr1.yaml
```

ESPHome erkennt den ESP im Netzwerk automatisch und bietet OTA als Upload-Option an.

---

## 10. Logs anzeigen

```bash
python -m esphome logs esphome/PowMr/powmr1.yaml
```

Nützlich zum:
- Prüfen ob WLAN-Verbindung steht
- Modbus-Kommunikation debuggen
- Sensordaten verifizieren

---

## 11. Fallback-Hotspot

Falls der ESP sich nicht mit dem WLAN verbinden kann, erstellt er einen eigenen Access Point:

- **SSID**: siehe `ap: ssid:` in der YAML (z. B. „My-Inverter Fallback Hotspot")
- **Passwort**: Wert aus `!secret ap_password`

Verbinde dich damit und öffne `192.168.4.1` im Browser, um WLAN-Daten einzugeben.

---

## 12. Eingebauter Web-Server

Alle Konfigurationen in diesem Repo aktivieren einen lokalen Web-Server auf dem ESP. Nach dem Boot ist das Gerät im Browser erreichbar:

```
http://<IP-Adresse-des-ESP>:80
```

Dort siehst du alle Sensoren, Schalter und Steuerelemente live – ohne Home Assistant oder MQTT.

Die IP-Adresse findest du:
- In den ESPHome-Logs nach dem Boot
- Im Router unter verbundene Geräte
- Über den Fallback-Hotspot (siehe Abschnitt 11)

---

## 13. Home Assistant einrichten

### Übersicht: Integrationsweg

Die Konfigurationen in diesem Repo verwenden **MQTT** (nicht die native ESPHome-API). Die Anbindung an Home Assistant erfolgt daher über die **MQTT-Integration** mit automatischer Discovery.

### Schritt 1: MQTT-Broker installieren

Falls noch kein MQTT-Broker läuft:

1. Home Assistant öffnen → **Einstellungen → Add-ons → Add-on Store**
2. **Mosquitto broker** suchen und installieren
3. Add-on starten und „Start bei Boot" aktivieren
4. Einen MQTT-Benutzer anlegen unter **Einstellungen → Personen → Benutzer** (oder in der Mosquitto-Konfiguration)

Die Zugangsdaten (Host = HA-IP, Username, Passwort) in deine `esphome/secrets.yaml` eintragen.

### Schritt 2: MQTT-Integration in Home Assistant aktivieren

1. **Einstellungen → Geräte & Dienste → Integration hinzufügen**
2. „MQTT" suchen und hinzufügen
3. Broker-Adresse: `localhost` (wenn Mosquitto auf dem gleichen HA läuft) oder die IP des Brokers
4. Port: `1883`
5. Benutzername und Passwort eingeben (gleiche wie in `secrets.yaml`)
6. **Speichern**

### Schritt 3: MQTT Discovery aktivieren (Standard)

ESPHome sendet standardmäßig Discovery-Nachrichten an das Topic `homeassistant/`. Home Assistant erkennt neue Geräte dadurch **automatisch**.

Nach dem Flashen und Booten des ESP:

1. Warte 10–30 Sekunden
2. Gehe zu **Einstellungen → Geräte & Dienste → MQTT**
3. Dein Gerät sollte unter dem konfigurierten `device_name` erscheinen (z. B. „powmr1", „wt1", „lumiax1")
4. Alle Sensoren und Steuerelemente werden automatisch als Entitäten angelegt

### Schritt 4: Entitäten prüfen

Unter **Einstellungen → Geräte & Dienste → MQTT → Geräte** findest du:
- Das Gerät mit `friendly_name` als Anzeigename
- Alle Sensoren (Spannung, Strom, Leistung, Temperatur usw.)
- Steuerbare Entitäten (Schalter, Selects, Numbers)

### Optional: Manuelles Topic-Debugging

Falls das Gerät nicht automatisch erscheint:

1. **Entwicklerwerkzeuge → MQTT → Auf ein Topic lauschen**
2. Topic: `#` eingeben und „Lauschen starten"
3. Prüfen ob Nachrichten vom ESP ankommen (z. B. `powmr1/sensor/...`)
4. Discovery-Topics prüfen: `homeassistant/#`

### Optional: Dashboard erstellen

1. **Übersicht → Dashboard bearbeiten → Karte hinzufügen**
2. Entitäten des Geräts auswählen (z. B. PV-Leistung, Batteriespannung)
3. Geeignete Kartentypen: Gauge, Verlaufsgraph, Entitäten-Karte

---

## 14. ioBroker als Alternative zu Home Assistant

Falls du statt Home Assistant **ioBroker** nutzt, funktioniert die Anbindung ebenfalls über MQTT.

### Schritt 1: MQTT-Adapter installieren

1. ioBroker Admin öffnen → **Adapter**
2. Nach „MQTT" suchen → **MQTT Broker/Client** installieren (Adapter `mqtt`)
3. Alternativ: **MQTT-Client** Adapter, falls du einen separaten Broker (z. B. Mosquitto) nutzt

### Schritt 2: Adapter konfigurieren

**Variante A – ioBroker als MQTT-Broker:**

1. Adapter-Einstellungen öffnen
2. Typ: **Server/Broker**
3. Port: `1883`
4. Authentifizierung aktivieren → Benutzer und Passwort setzen
5. Diese Zugangsdaten in `esphome/secrets.yaml` eintragen (`mqtt_host` = IP des ioBroker-Servers)

**Variante B – Externer Broker (z. B. Mosquitto):**

1. Typ: **Client**
2. Broker-URL: IP des Mosquitto-Servers
3. Port: `1883`
4. Benutzer/Passwort des Brokers eingeben
5. Subscribe-Pattern: `#` oder spezifisch z. B. `powmr1/#`, `wt1/#`

### Schritt 3: Datenpunkte prüfen

Nach dem Booten des ESP erscheinen die Datenpunkte automatisch unter:

```
mqtt.0.<device_name>.<component_type>.<sensor_name>
```

Beispiele:
- `mqtt.0.powmr1.sensor.battery_voltage.state`
- `mqtt.0.wt1.sensor.output_voltage.state`
- `mqtt.0.lumiax1.sensor.pv_power.state`

### Schritt 4: Visualisierung (VIS / Jarvis / Grafana)

- **VIS**: Datenpunkte direkt in Widgets verwenden (Gauge, Wert-Anzeige, Chart)
- **Grafana**: InfluxDB-Adapter installieren → Datenpunkte loggen → Grafana-Dashboards bauen
- **Jarvis**: Geräte anlegen und MQTT-Datenpunkte zuweisen

### Steuerung vom ioBroker aus

Um Werte an den ESP zu senden (z. B. Schalter oder Einstellungen), schreibe auf das entsprechende Command-Topic:

```
mqtt.0.<device_name>/<component_type>/<entity_name>/command
```

Beispiel in einem JavaScript-Adapter-Skript:

```javascript
sendTo('mqtt.0', 'sendMessage2Client', {
    topic: 'powmr1/select/output_source_priority/command',
    message: 'Solar first'
});
```

### Tipp: MQTT Explorer

Installiere [MQTT Explorer](http://mqtt-explorer.com/) auf deinem PC, um alle Topics live zu sehen. Das hilft beim Debugging und beim Finden der richtigen Datenpunkte.

---

## 15. Externe Komponenten (GitHub-Dependencies)

Einige Konfigurationen laden Komponenten direkt von GitHub:

| Konfiguration          | Externe Quelle                                    |
| ---------------------- | ------------------------------------------------- |
| `pip5048_seplos.yaml`  | `github://syssi/esphome-seplos-bms`               |
| BLE-Beispiele (PowMr) | `github://syssi/esphome-jk-bms`                   |

Diese werden beim ersten Kompilieren automatisch heruntergeladen. Eine Internetverbindung ist dafür erforderlich. Bei Problemen:

```bash
# Cache leeren und neu herunterladen
python -m esphome clean esphome/pip5048_seplos.yaml
python -m esphome run esphome/pip5048_seplos.yaml
```

---

## Kurzreferenz: Wichtige Befehle

| Befehl | Zweck |
| ------ | ----- |
| `python -m esphome config <yaml>` | Konfiguration validieren |
| `python -m esphome compile <yaml>` | Nur kompilieren (nicht flashen) |
| `python -m esphome run <yaml>` | Kompilieren + Flashen (USB oder OTA) |
| `python -m esphome logs <yaml>` | Live-Logs anzeigen |
| `python -m esphome clean <yaml>` | Build-Cache löschen |

---

## Troubleshooting

| Problem | Lösung |
| ------- | ------ |
| USB-Port nicht erkannt | Datenkabel verwenden, Treiber installieren |
| Kompilierung schlägt fehl | `python -m esphome config` ausführen, Fehler lesen |
| WLAN verbindet nicht | SSID/Passwort in secrets.yaml prüfen, Sonderzeichen in Anführungszeichen |
| Modbus-Fehler in Logs | TX/RX-Pins prüfen, Baud-Rate prüfen, Adresse prüfen |
| OTA findet Gerät nicht | ESP und PC im gleichen Netzwerk/Subnetz? |
| ESP bootet nicht nach Flash | Flash-Größe in YAML prüfen (`flash_size`) |
