# ESPHome Build-Script für Seplos-Projekt
# Verwendung:
#   .\run.ps1             -> zeigt Hilfe
#   .\run.ps1 compile     -> nur kompilieren (kein Flash)
#   .\run.ps1 upload      -> kompilieren + per USB flashen
#   .\run.ps1 ota         -> kompilieren + per OTA flashen
#   .\run.ps1 logs        -> serielle Logs anzeigen
#   .\run.ps1 run         -> kompilieren + flashen + Logs
#   .\run.ps1 validate    -> YAML-Syntax prüfen

param(
    [Parameter(Position=0)]
    [ValidateSet("compile","upload","ota","logs","run","validate","")]
    [string]$Command = ""
)

$ErrorActionPreference = "Stop"
$ConfigFile = "esphome\pipseplos02.yaml"
# venv liegt im scripts/-Ordner eine Ebene höher
$ESPHome    = "..\scripts\.venv\Scripts\esphome.exe"

function Invoke-ESPHome {
    param([string[]]$EspArgs)

    if (Test-Path $ESPHome) {
        & $ESPHome @EspArgs
    } elseif (Get-Command esphome -ErrorAction SilentlyContinue) {
        esphome @EspArgs
    } else {
        Write-Error "ESPHome nicht gefunden unter: $ESPHome`nBitte scripts\setup-esphome.ps1 ausführen."
        exit 1
    }
}

Write-Host "=== Seplos BMS ESPHome ===" -ForegroundColor Cyan
Write-Host "Config: $ConfigFile" -ForegroundColor Gray
Write-Host ""

switch ($Command) {
    "compile" {
        Write-Host "Kompiliere..." -ForegroundColor Yellow
        Invoke-ESPHome "compile", $ConfigFile
    }
    "upload" {
        Write-Host "Kompiliere und flashe per USB..." -ForegroundColor Yellow
        Invoke-ESPHome "upload", $ConfigFile
    }
    "ota" {
        Write-Host "Kompiliere und flashe per OTA..." -ForegroundColor Yellow
        Invoke-ESPHome "upload", "--device", "OTA", $ConfigFile
    }
    "logs" {
        Write-Host "Zeige Logs (Strg+C zum Beenden)..." -ForegroundColor Yellow
        Invoke-ESPHome "logs", $ConfigFile
    }
    "run" {
        Write-Host "Kompiliere, flashe und zeige Logs..." -ForegroundColor Yellow
        Invoke-ESPHome "run", $ConfigFile
    }
    "validate" {
        Write-Host "Prüfe YAML-Syntax..." -ForegroundColor Yellow
        Invoke-ESPHome "config", $ConfigFile
    }
    default {
        Write-Host "Verfügbare Befehle:" -ForegroundColor White
        Write-Host "  .\run.ps1 validate   -> YAML-Syntax prüfen"         -ForegroundColor Gray
        Write-Host "  .\run.ps1 compile    -> nur kompilieren"             -ForegroundColor Gray
        Write-Host "  .\run.ps1 upload     -> kompilieren + USB-Flash"     -ForegroundColor Gray
        Write-Host "  .\run.ps1 ota        -> kompilieren + OTA-Flash"     -ForegroundColor Gray
        Write-Host "  .\run.ps1 logs       -> serielle Logs anzeigen"      -ForegroundColor Gray
        Write-Host "  .\run.ps1 run        -> compile + flash + logs"      -ForegroundColor Gray
        Write-Host ""
        Write-Host "Hinweise:" -ForegroundColor White
        Write-Host "  - secrets.yaml in esphome\ anpassen (WLAN, MQTT, etc.)"  -ForegroundColor DarkYellow
        Write-Host "  - Baudrate und BMS-Adresse in seplos_hagen.yaml prüfen"  -ForegroundColor DarkYellow
        Write-Host "  - Web-UI nach dem Flash unter http://seplos-hagen.local" -ForegroundColor DarkYellow
    }
}
