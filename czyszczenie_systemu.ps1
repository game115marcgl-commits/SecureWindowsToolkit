# czyszczenie_systemu.ps1
# Autor: Marcel, Elbląg 🇵🇱
# Cel: Automatyczne czyszczenie systemu Windows z plików tymczasowych i śmieci

Write-Host "🔧 Rozpoczynam czyszczenie systemu..." -ForegroundColor Cyan

# Czyszczenie folderów tymczasowych
$tempFolders = @(
    "$env:TEMP",
    "$env:USERPROFILE\AppData\Local\Temp",
    "C:\Windows\Temp"
)

foreach ($folder in $tempFolders) {
    if (Test-Path $folder) {
        Write-Host "🧹 Czyszczenie: $folder"
        Get-ChildItem -Path $folder -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    }
}

# Opróżnianie kosza
Write-Host "🗑️ Opróżnianie kosza..."
$shell = New-Object -ComObject Shell.Application
$recycleBin = $shell.Namespace(0xA)
$recycleBin.Items() | ForEach-Object { Remove-Item $_.Path -Force -Recurse -ErrorAction SilentlyContinue }

# Czyszczenie folderu Prefetch
$prefetch = "C:\Windows\Prefetch"
if (Test-Path $prefetch) {
    Write-Host "📦 Czyszczenie Prefetch..."
    Get-ChildItem -Path $prefetch -Force | Remove-Item -Force -ErrorAction SilentlyContinue
}

# Zapis logu
$logPath = "$env:USERPROFILE\Desktop\log_czyszczenia.txt"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
Add-Content -Path $logPath -Value "[$timestamp] Wykonano czyszczenie systemu: foldery tymczasowe, kosz, Prefetch"

Write-Host "`n✅ Gotowe! System został oczyszczony." -ForegroundColor Green
Write-Host "📄 Log zapisany na pulpicie: log_czyszczenia.txt"
