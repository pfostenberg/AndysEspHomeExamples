# Lötanleitung: Tasmota4rs485 – ESPHome Interfaceplatin

Diese Platine vereinheitlicht alle Komponenten für die Verbindung von Solaranlagen, Wechselrichtern und Speichersystemen mit ESPHome.

**Bilder:** `./Bilder/Platine-IMG_*.jpg`  
**Schaltpläne:** `./Schaltpläne/Tasmota4rs485_Schaltplan.pdf` (Schaltplan) und `Tasmota4rs485_BS.pdf` (Bestückungsplan)

---

## Überblick: Funktionen der Platine

- **ESP32-S3 / ESP32 / ESP8266 Träger** – Hauptcontroller für ESPHome
- **Modbus RS485 Interface** – Kommunikation mit Invertern, BMSs, Ladereglern via UART
- **Power Distribution** – 12/24V Input → Lokale Versorgung
- **Schutzkomponenten** – TVS-Dioden, Widerstände für ESD-Sicherheit
- **Connector-Leiste** – Standardisierte Ausgänge (RX/TX, Power, GND)
- **Decoupling Capacitors** – Für stabile Stromversorgung

---

## Komponenten

### Lokalisierung auf der PCB

| Designator | Typ | Wert / Typ | Funktion |
| ---------- | --- | --------- | -------- |
| C1–C10 | Kondensator | 0.1µF / 10µF (siehe Siebdruck) | Entkopplung, Puffern |
| R1–R20 | Widerstand | 4.7kΩ, 10kΩ, 220Ω (gemäß Schaltplan) | Pull-Up/Pull-Down, Strombegrenzung |
| D1–D4 | TVS-Diode | ~5V (z.B. SMAJ5.0A) | ESD-Schutz |
| U1 | RS485-Transceiver | MAX485 oder SN65HVD372 | UART → RS485 |
| U2 (optional) | LDO-Regler | AMS1117-3.3V oder LM1117 | 5V → 3.3V |
| CN1–CN3 | JST-Stecker | 2.54mm Pitch | Strom, RX/TX, GND |
| Lötpads | – | – | ESP32-S3 Direct-Mount möglich |
 Reflow-Ofen ~240–260°C, wenn verfügbar. Sonst mit Lötkolben (350°C) einzeln.

## Kritische Verbindungen

| Verbindung | Empfindlich | Anmerkung |
| ---------- | --------- | --------- |
| ESP32 RX/TX → RS485 U1 | JA | Nur 3.3V! TVS-Dioden auf jeden Fall verlöten |
| Power-Eingänge (12/24V) | JA | Polung triple-prüfen; Verpolung zerstört den Regler |
| MAX485 AB-Leitungen | MITTEL | Terminierungswiderstände (120Ω) an beiden Enden des RS485-Busses! |

| Problem | Ursache | Lösung |
| ------- | ------ | ------ |
| Keine Kommunikation über RS485 | MAX485 IC falsch gepolt oder nicht gelötet | IC aus dem Bestückungsdruck folgen; Durchgang-Test durchführen |
| ESP bootet nicht | Rückseite des Lötkolbens zu lange auf Pad (Verbrannt), oder Kurz VCC-GND | Mit Ohm-Meter vor Inbetriebnahme prüfen |
| Intermittierende UART-Fehler | Kaltlötstellen oder oxidierte Pads | Mit Entlötlitze nochmal durchlöten, Oxid mit Bürste entfernen |
| Überhitzung des Reglers (U2) | Zu hohe Input-Spannung oder zu viel Last | Spannung prüfen, ggf. Step-Down-Regler vorschalten |

---
### Erste Inbetriebnahme
1. **Ohm-Test vor Stromzufuhr:**
   - VCC gegen GND: > 1 MΩ (kein Kurzschluss!)
   - TX-Pin gegen GND: 0 Ω (via Transceiver)
   - RX-Pin gegen GND: 0 Ω (via Transceiver)

2. **ESP flashen** (siehe [HOWTO.md](HOWTO.md), Abschnitt 8):
   ```bash
   python -m esphome run esphome/PowMr/powmr1.yaml
   ```

3. **Im Web-Browser testen:**
   - IP des ESP im Browser öffnen (z.B. `192.168.1.100`)
   - Dashboard sollte laden
   - Sensoren in MQTT / Home Assistant / ioBroker erscheinen

---

## Ersatzteile

| Part | Distributor | Alternative |
| ---- | -------- | ------ |
| MAX485 | AliExpress, Reichelt | SN65HVD372 (3.3V-tolerant) |
| ESP32-S3 DevKit | AliExpress, AZ-Delivery | ESP32-S3-WROOM-1 |
| TVS 5V | Reichelt, Mouser | SMAJ5.0A oder SM6T5.0A |
| LDO Regler | AliExpress | AMS1117-3.3 oder LM1117-3.3 |

---

## Parametrierung nach dem Flashen

Nach erfolgreichem Boot:
1. **Secrets prüfen** ([HOWTO.md](HOWTO.md) Abschnitt 5)
2. **UART-Pins in der YAML** gegen die Platine abgleichen
3. **MQTT-Broker** verfügbar und konfiguriert?
4. **Logs checken:**
   ```bash
   python -m esphome logs esphome/PowMr/powmr1.yaml
   ```
   → Sollte WLAN-Verbindung und Modbus-Kommunikation zeigen

Wenn Fehler: Siehe [HOWTO.md](HOWTO.md) Abschnitt "Troubleshooting".
