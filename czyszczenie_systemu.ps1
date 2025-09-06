# czyszczenie_systemu.ps1 - Wersja 2.0
# Autor: Marcel, Elbląg 🇵🇱
# Cel: Automatyczne czyszczenie systemu Windows z plików tymczasowych i śmieci

# --- Konfiguracja ---
$logPath = "$env:USERPROFILE\Desktop\log_czyszczenia.txt"

# --- Funkcja do logowania ---
function Write-Log {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $logPath -Value "[$timestamp] $message"
}

# --- Start ---
Write-Host "🔧 Rozpoczynam czyszczenie systemu..." -ForegroundColor Cyan
Write-Log "ROZPOCZĘTO CZYSZCZENIE SYSTEMU"

# --- Czyszczenie folderów tymczasowych ---
$tempFolders = @(
    "$env:TEMP", # Ten i poniższy to często ten sam folder, ale upewniamy się
    "C:\Windows\Temp"
)

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Write-Host "🧹 Czyszczenie: $folder"
        Write-Log "Czyszczenie folderu: $folder"
        try {
            # Używamy zoptymalizowanej metody usuwania i łapiemy ewentualne błędy
            Remove-Item -Path "$folder\*" -Recurse -Force -ErrorAction Stop
        }
        catch {
            Write-Log "BŁĄD przy czyszczeniu $folder : $($_.Exception.Message)"
        }
    }
}

# --- Opróżnianie kosza ---
Write-Host "🗑️ Opróżnianie kosza..."
Write-Log "Opróżnianie kosza"
try {
    # Używamy nowoczesnego i prostego polecenia PowerShell
    Clear-RecycleBin -Force -ErrorAction Stop
}
catch {
    Write-Log "BŁĄD przy opróżnianiu kosza: $($_.Exception.Message)"
}


# --- Czyszczenie folderu Prefetch ---
$prefetchPath = "C:\Windows\Prefetch"
if (Test-Path $prefetchPath) {
    Write-Host "📦 Czyszczenie Prefetch..."
    Write-Log "Czyszczenie folderu Prefetch"
    try {
        Remove-Item -Path "$prefetchPath\*" -Force -ErrorAction Stop
    }
    catch {
        Write-Log "BŁĄD przy czyszczeniu Prefetch: $($_.Exception.Message)"
    }
}

# --- Koniec ---
Write-Log "ZAKOŃCZONO CZYSZCZENIE SYSTEMU"
Write-Host "`n✅ Gotowe! System został oczyszczony." -ForegroundColor Green
Write-Host "📄 Log zapisany na pulpicie: $logPath"
