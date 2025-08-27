# wyłącz_usługi.ps1
# Autor: Marcel, Elbląg 🇵🇱
# Cel: Wyłączenie zbędnych usług systemowych w Windows

Write-Host "🔧 Rozpoczynam wyłączanie zbędnych usług..." -ForegroundColor Cyan

$uslugi = @(
    "DiagTrack",                  # Telemetria systemu Windows
    "XblGameSave",                # Xbox Game Save
    "XboxNetApiSvc",              # Xbox Live Networking Service
    "WMPNetworkSvc",              # Udostępnianie multimediów
    "RetailDemo",                 # Tryb demonstracyjny
    "MapsBroker",                 # Usługi map
    "Fax",                        # Usługa faksu
    "RemoteRegistry"             # Zdalna edycja rejestru
)

$logPath = "$env:USERPROFILE\Desktop\log_uslug.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logPath -Value "`n[$timestamp] Rozpoczęto wyłączanie usług..."

foreach ($nazwa in $uslugi) {
    Write-Host "🛑 Przetwarzanie: $nazwa"

    if (Get-Service -Name $nazwa -ErrorAction SilentlyContinue) {
        try {
            Stop-Service -Name $nazwa -Force -ErrorAction SilentlyContinue
            Set-Service -Name $nazwa -StartupType Disabled
            Write-Host "✅ Usługa $nazwa została wyłączona." -ForegroundColor Green
            Add-Content -Path $logPath -Value "Usługa $nazwa: WYŁĄCZONA"
        } catch {
            Write-Host "⚠️ Błąd przy wyłączaniu: $nazwa" -ForegroundColor Yellow
            Add-Content -Path $logPath -Value "Usługa $nazwa: BŁĄD"
        }
    } else {
        Write-Host "ℹ️ Usługa $nazwa nie istnieje w systemie." -ForegroundColor Gray
        Add-Content -Path $logPath -Value "Usługa $nazwa: NIE ZNALEZIONA"
    }
}

Write-Host "`n📄 Log zapisany na pulpicie: log_uslug.txt"
Write-Host "✅ Gotowe! Wszystkie usługi zostały przetworzone." -ForegroundColor Cyan
