#!/bin/bash
# ESPHome Setup Script für Linux / macOS
# Erstellt venv, aktiviert es und installiert ESPHome falls nicht vorhanden

set -e

VENV_PATH=".venv"
FORCE_REBUILD=false
PYTHON_CMD="python3"

# Parse Argumente
while [[ $# -gt 0 ]]; do
    case $1 in
        --force)
            FORCE_REBUILD=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo "=== ESPHome Setup Script für Linux/macOS ===" 
echo ""

# Prüfe Python
echo "[1/4] Python-Installation wird geprüft..."
if ! command -v $PYTHON_CMD &> /dev/null; then
    echo "✗ Python 3 nicht gefunden. Bitte installieren mit:"
    echo "  Ubuntu/Debian: sudo apt install python3 python3-venv"
    echo "  macOS: brew install python3"
    exit 1
fi

PYTHON_VERSION=$($PYTHON_CMD --version)
echo "✓ $PYTHON_VERSION gefunden"

# Erstelle venv wenn nötig
echo ""
echo "[2/4] Virtuelle Umgebung wird vorbereitet..."

if [ -d "$VENV_PATH" ] && [ "$FORCE_REBUILD" = false ]; then
    echo "✓ venv existiert bereits unter: $VENV_PATH"
else
    if [ -d "$VENV_PATH" ] && [ "$FORCE_REBUILD" = true ]; then
        echo "  Alte venv wird gelöscht (--force)..."
        rm -rf "$VENV_PATH"
    fi
    
    echo "  Erstelle neue venv..."
    $PYTHON_CMD -m venv "$VENV_PATH"
    
    if [ $? -eq 0 ]; then
        echo "✓ venv erfolgreich erstellt"
    else
        echo "✗ Fehler beim Erstellen der venv"
        exit 1
    fi
fi

# Aktiviere venv
echo ""
echo "[3/4] Virtuelle Umgebung wird aktiviert..."
source "$VENV_PATH/bin/activate"

if [ $? -eq 0 ]; then
    echo "✓ venv aktiviert"
else
    echo "✗ Fehler beim Aktivieren der venv"
    exit 1
fi

# Prüfe und installiere ESPHome
echo ""
echo "[4/4] ESPHome wird geprüft/installiert..."

if esphome version &> /dev/null; then
    ESPHOME_VERSION=$(esphome version 2>&1 | head -n 1)
    echo "✓ ESPHome ist bereits installiert: $ESPHOME_VERSION"
else
    echo "  ESPHome wird installiert (dies kann 1-2 Minuten dauern)..."
    python -m pip install --upgrade pip > /dev/null
    python -m pip install esphome
    
    if [ $? -eq 0 ]; then
        echo "✓ ESPHome erfolgreich installiert"
    else
        echo "✗ Fehler beim Installieren von ESPHome"
        exit 1
    fi
fi

echo ""
echo "=== Setup erfolgreich abgeschlossen ===" 
echo ""
echo "Nächste Schritte:"
echo "1. Secrets konfigurieren: cp esphome/secrets.example.yaml esphome/secrets.yaml"
echo "2. YAML-Datei validieren: python -m esphome config esphome/PowMr/powmr1.yaml"
echo "3. ESP flashen: python -m esphome run esphome/PowMr/powmr1.yaml"
echo ""
echo "Für Hilfe: siehe HOWTO.md"
