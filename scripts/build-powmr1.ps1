param(
    [Parameter(Position = 0)]
    [ValidateSet("compile", "validate", "upload", "ota", "logs", "run", "help")]
    [string]$Command = "compile",
    [string]$Device = ""
)

$ErrorActionPreference = "Stop"
$RepoRoot = Split-Path -Parent $PSScriptRoot
$ConfigFile = Join-Path $RepoRoot "esphome\powmr1.yaml"
$ESPHome = $null

Write-Host "=== PowMr ESPHome Build ===" -ForegroundColor Cyan
Write-Host "Config: $ConfigFile" -ForegroundColor Gray

if ($Command -eq "help") {
    Write-Host "Verwendung: .\scripts\build-powmr1.ps1 [Befehl] [-Device COM3|IP|Hostname]"
    Write-Host "  compile  : Kompilieren (Standard, kein Flash)"
    Write-Host "  validate : Konfiguration pruefen"
    Write-Host "  upload   : Kompilieren und flashen"
    Write-Host "  ota      : Kompilieren und per Netzwerk flashen (Standard: powmr1.local)"
    Write-Host "  logs     : Logs anzeigen (Strg+C zum Beenden)"
    Write-Host "  run      : Kompilieren, flashen und Logs anzeigen"
    exit 0
}

if (-not (Test-Path -LiteralPath $ConfigFile -PathType Leaf)) {
    throw "Konfiguration nicht gefunden: $ConfigFile"
}

foreach ($Candidate in @(
    (Join-Path $PSScriptRoot ".venv\Scripts\esphome.exe"),
    (Join-Path $RepoRoot ".venv\Scripts\esphome.exe")
)) {
    if (Test-Path -LiteralPath $Candidate -PathType Leaf) {
        $ESPHome = $Candidate
        break
    }
}

if (-not $ESPHome) {
    $InstalledCommand = Get-Command esphome -CommandType Application -ErrorAction SilentlyContinue
    if ($InstalledCommand) {
        $ESPHome = $InstalledCommand.Source
    } else {
        throw "ESPHome fehlt. Zuerst scripts\setup-esphome.ps1 ausfuehren."
    }
}

function Invoke-ESPHome {
    param([string[]]$EspArgs)

    & $ESPHome @EspArgs
    if ($LASTEXITCODE -ne 0) {
        exit $LASTEXITCODE
    }
}

$DeviceArgs = @()
if ($Device) {
    $DeviceArgs = @("--device", $Device)
}

switch ($Command) {
    "compile" {
        Invoke-ESPHome -EspArgs @("compile", $ConfigFile)
    }
    "validate" {
        Invoke-ESPHome -EspArgs @("config", $ConfigFile)
    }
    "upload" {
        Invoke-ESPHome -EspArgs @("compile", $ConfigFile)
        Invoke-ESPHome -EspArgs (@("upload", $ConfigFile) + $DeviceArgs)
    }
    "ota" {
        if (-not $Device) {
            $DeviceArgs = @("--device", "powmr1.local")
        }
        Invoke-ESPHome -EspArgs @("compile", $ConfigFile)
        Invoke-ESPHome -EspArgs (@("upload", $ConfigFile) + $DeviceArgs)
    }
    "logs" {
        Invoke-ESPHome -EspArgs (@("logs", $ConfigFile) + $DeviceArgs)
    }
    "run" {
        Invoke-ESPHome -EspArgs (@("run", $ConfigFile) + $DeviceArgs)
    }
}