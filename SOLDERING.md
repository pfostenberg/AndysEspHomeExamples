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

---

## Lötsequenz (Profis)

### Phase 1: Platinen-Prep
1. Sichtprüfung: Kratzer, Risse, durchgehende Pads?
2. Lötpaste (Blei-frei oder Blei: SnPb63) auftragen (oder manuell löten)

### Phase 2: SMD-Bauteile (0805 / 1206 Widerstände, Kondensatoren)
1. Kleinste Widerstände zuerst (R-Series)
2. Kondensatoren (von oben nach unten)
3. Dioden (Polung prüfen: Stripe = Kathode)
4. ICs (MAX485) – Pad-Ausrichtung triple-prüfen

**Profitipp:** Reflow-Ofen ~240–260°C, wenn verfügbar. Sonst mit Lötkolben (350°C) einzeln.

### Phase 3: Stecker & Durchstecklöcher
1. JST-Stecker in die Pads einlegen (Kontakte müssen frei sein)
2. Pin-Header (2.54mm) für ESP-Anschluss einsetzen
3. Rückseite: Kupfer-Pads gut verzinnen vor dem Einlöten
4. Mit Zinn durchflussmittel (Paste) für sichere Verbindungen

### Phase 4: Power-Anschlüsse
1. GND-Pads zuerst löten (thermische Massen!)
2. VCC/12V-Pads direkt danach
3. Kurzkontrolle mit Multimeter durchführen

### Phase 5: Quality Check
1. Durchgangstest: GND → alle GND-Pads
2. Isolationsprüfung: VCC gegen GND (mind. 1 MΩ bei kaltem Gerät)
3. Sichtprüfung Lötbrücken under Video-Microscope (~50x)

---

## Schaltplan-Referenz

Siehe die PDFs im Ordner `./Schaltpläne/`:

### Tasmota4rs485_Schaltplan.pdf
- Komplette Schaltung mit allen Verbindungen
- Designatoren (R1, R2, C1 usw.) folgen diesem Schaltplan – **nicht den Bildern!**
- IC-Positionen und Pin-Belegungen: Hier prüfen vor dem Löten
- Polung von ICs: Pin 1 = meist oben-links im Schaltplan markiert

### Tasmota4rs485_BS.pdf (Bestückungsplan)
- Physische Anordnung der Bauteile auf der PCB
- Rote Flächen = Bestückungsseite (oben)
- Grüne/blaue Flächen = Rückseite (wenn SMD-Bestückung)
- Verwende dies **parallel zur Platine** beim Löten – Designatoren und Positionen abgleichen

### Best Practice beim Löten
1. **Schaltplan öffnen** → Designator suchen (z.B. „C1")
2. **Bestückungsplan** → Position auf der PCB ablesen
3. **Wert aus Schaltplan** → z.B. „C1 = 10µF" → Bauteil besorgen und einlöten
4. **Strompfade nachverfolgbar?** GND sollte durchgehende Kupferplatte sein → In PDF sichtbar

---

## Kritische Verbindungen

| Verbindung | Empfindlich | Anmerkung |
| ---------- | --------- | --------- |
| ESP32 RX/TX → RS485 U1 | JA | Nur 3.3V! TVS-Dioden auf jeden Fall verlöten |
| Power-Eingänge (12/24V) | JA | Polung triple-prüfen; Verpolung zerstört den Regler |
| MAX485 AB-Leitungen | MITTEL | Terminierungswiderstände (120Ω) an beiden Enden des RS485-Busses! |
| GND-Planes | WICHTIG | Alle GND sollten sehr niederohmig verbunden sein |

---

## Häufige Fehler

| Problem | Ursache | Lösung |
| ------- | ------ | ------ |
| Keine Kommunikation über RS485 | MAX485 IC falsch gepolt oder nicht gelötet | IC aus dem Bestückungsdruck folgen; Durchgang-Test durchführen |
| ESP bootet nicht | Rückseite des Lötkolbens zu lange auf Pad (Verbrannt), oder Kurz VCC-GND | Mit Ohm-Meter vor Inbetriebnahme prüfen |
| Intermittierende UART-Fehler | Kaltlötstellen oder oxidierte Pads | Mit Entlötlitze nochmal durchlöten, Oxid mit Bürste entfernen |
| Überhitzung des Reglers (U2) | Zu hohe Input-Spannung oder zu viel Last | Spannung prüfen, ggf. Step-Down-Regler vorschalten |

---

## Nach dem Löten

### Reinigung
```bash
Isopropanol (IPA) + weiche Bürste → alle Flussmittelreste weg
Optional: Ultraschallreinigung bei hartnäckigen Resten
```

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

## Tipp: Parametrierung nach dem Flashen

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
