# ESPHome Setup Script für Windows (PowerShell)
# Erstellt venv, aktiviert es und installiert ESPHome falls nicht vorhanden

param(
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"
$venvPath = ".\.venv"
$pythonCmd = "python"

Write-Host "=== ESPHome Setup Script für Windows ===" -ForegroundColor Cyan
Write-Host ""

# Prüfe Python
Write-Host "[1/4] Python-Installation wird geprüft..." -ForegroundColor Yellow
try {
    $pythonVersion = & $pythonCmd --version 2>&1
    Write-Host "✓ Python gefunden: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "✗ Python nicht gefunden. Bitte Python 3.10+ installieren:" -ForegroundColor Red
    Write-Host "  https://www.python.org/downloads/" -ForegroundColor White
    exit 1
}

# Erstelle venv wenn nötig
Write-Host ""
Write-Host "[2/4] Virtuelle Umgebung wird vorbereitet..." -ForegroundColor Yellow

if ((Test-Path $venvPath) -and -not $Force) {
    Write-Host "✓ venv existiert bereits unter: $venvPath" -ForegroundColor Green
} else {
    if ($Force -and (Test-Path $venvPath)) {
        Write-Host "  Alte venv wird gelöscht (--Force)..."
        Remove-Item $venvPath -Recurse -Force | Out-Null
    }
    
    Write-Host "  Erstelle neue venv..."
    & $pythonCmd -m venv $venvPath
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ venv erfolgreich erstellt" -ForegroundColor Green
    } else {
        Write-Host "✗ Fehler beim Erstellen der venv" -ForegroundColor Red
        exit 1
    }
}

# Aktiviere venv
Write-Host ""
Write-Host "[3/4] Virtuelle Umgebung wird aktiviert..." -ForegroundColor Yellow
$activateScript = "$venvPath\Scripts\Activate.ps1"

if (Test-Path $activateScript) {
    & $activateScript
    Write-Host "✓ venv aktiviert" -ForegroundColor Green
} else {
    Write-Host "✗ Aktivierungsskript nicht gefunden: $activateScript" -ForegroundColor Red
    exit 1
}

# Prüfe und installiere ESPHome
Write-Host ""
Write-Host "[4/4] ESPHome wird geprüft/installiert..." -ForegroundColor Yellow

try {
    $esphomeVersion = & esphome version 2>&1 | Select-Object -First 1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ ESPHome ist bereits installiert: $esphomeVersion" -ForegroundColor Green
    } else {
        throw "ESPHome nicht gefunden"
    }
} catch {
    Write-Host "  ESPHome wird installiert (dies kann 1-2 Minuten dauern)..."
    & python -m pip install --upgrade pip | Out-Null
    & python -m pip install esphome
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ ESPHome erfolgreich installiert" -ForegroundColor Green
    } else {
        Write-Host "✗ Fehler beim Installieren von ESPHome" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "=== Setup erfolgreich abgeschlossen ===" -ForegroundColor Green
Write-Host ""
Write-Host "Nächste Schritte:" -ForegroundColor Cyan
Write-Host "1. Secrets konfigurieren: cp esphome/secrets.example.yaml esphome/secrets.yaml"
Write-Host "2. YAML-Datei validieren: python -m esphome config esphome/PowMr/powmr1.yaml"
Write-Host "3. ESP flashen: python -m esphome run esphome/PowMr/powmr1.yaml"
Write-Host ""
Write-Host "Für Hilfe: siehe HOWTO.md" -ForegroundColor White
