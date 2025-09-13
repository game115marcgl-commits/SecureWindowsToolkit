<#
.SYNOPSIS
    Uruchamia SecureWindowsToolkit po weryfikacji wymagań bezpieczeństwa systemu.

.DESCRIPTION
    Ten skrypt działa jak strażnik. Zanim uruchomi główny interfejs narzędzia,
    sprawdza, czy system spełnia kluczowe, nowoczesne standardy bezpieczeństwa,
    takie jak TPM, Secure Boot i VBS. Jeśli weryfikacja się nie powiedzie,
    skrypt wyświetli szczegółowy raport o brakach i zakończy działanie.

.AUTHOR
    Marcel, Elbląg 🇵🇱
#>

# --- Blokada przed "kombinowaniem" ---
# Upewniamy się, że skrypt jest uruchomiony z pełnymi uprawnieniami
# i w odpowiednim środowisku. Jeśli nie, kończymy od razu.
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "BŁĄD: Ten skrypt musi być uruchomiony jako Administrator!" -ForegroundColor Red
    Write-Host "Kliknij na niego prawym przyciskiem myszy i wybierz 'Uruchom jako administrator'."
    Read-Host "Wciśnij Enter, aby zakończyć."
    exit
}

Clear-Host
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "  Witaj w SecureWindowsToolkit by Marcel"
Write-Host "  Przeprowadzam audyt bezpieczeństwa systemu..."
Write-Host "==================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 2

# --- Faza 1: Weryfikacja Wymagań ---
$wymaganiaSpelnione = $true
$raportBledow = @()

# Sprawdzenie 1: TPM 2.0
Write-Host "🔍 Sprawdzam TPM 2.0..." -NoNewline
try {
    $tpm = Get-Tpm
    if ($tpm.TpmPresent -and $tpm.TpmReady) {
        Write-Host " OK" -ForegroundColor Green
    } else {
        $wymaganiaSpelnione = $false
        $raportBledow += "❌ TPM: Moduł TPM nie jest obecny lub nie jest gotowy. Sprawdź ustawienia w BIOS/UEFI."
        Write-Host " BŁĄD" -ForegroundColor Red
    }
} catch {
    $wymaganiaSpelnione = $false
    $raportBledow += "❌ TPM: Nie można odczytać statusu TPM. Uruchom skrypt jako Administrator."
    Write-Host " BŁĄD" -ForegroundColor Red
}

# Sprawdzenie 2: Secure Boot
Write-Host "🔍 Sprawdzam Secure Boot..." -NoNewline
try {
    $secureBootStatus = Confirm-SecureBootUEFI
    if ($secureBootStatus) {
        Write-Host " OK" -ForegroundColor Green
    } else {
        $wymaganiaSpelnione = $false
        $raportBledow += "❌ Secure Boot: Bezpieczny Rozruch jest wyłączony. Sprawdź ustawienia w BIOS/UEFI."
        Write-Host " BŁĄD" -ForegroundColor Red
    }
} catch {
    $wymaganiaSpelnione = $false
    $raportBledow += "❌ Secure Boot: Nie można sprawdzić statusu. Upewnij się, że system jest w trybie UEFI."
    Write-Host " BŁĄD" -ForegroundColor Red
}

# Sprawdzenie 3: Zabezpieczenia oparte na wirtualizacji (VBS)
Write-Host "🔍 Sprawdzam Zabezpieczenia oparte na wirtualizacji (VBS)..." -NoNewline
try {
    $vbsInfo = Get-CimInstance -ClassName Win32_DeviceGuard -Namespace "root\Microsoft\Windows\DeviceGuard"
    if ($vbsInfo.VirtualizationBasedSecurityStatus -eq 2) { # Wartość 2 oznacza "Running"
        Write-Host " OK" -ForegroundColor Green
    } else {
        $wymaganiaSpelnione = $false
        $raportBledow += "❌ VBS: Zabezpieczenia oparte na wirtualizacji są wyłączone. Włącz Intel VT-x w BIOS/UEFI oraz Izolację Rdzenia w Zabezpieczeniach Windows."
        Write-Host " BŁĄD" -ForegroundColor Red
    }
} catch {
    $wymaganiaSpelnione = $false
    $raportBledow += "❌ VBS: Nie można sprawdzić statusu VBS."
    Write-Host " BŁĄD" -ForegroundColor Red
}

Start-Sleep -Seconds 1

# --- Faza 2: Decyzja ---
if ($wymaganiaSpelnione) {
    Write-Host "`n==================================================" -ForegroundColor Green
    Write-Host "  AUDYT ZAKOŃCZONY POMYŚLNIE!"
    Write-Host "  Twój system spełnia wysokie standardy bezpieczeństwa."
    Write-Host "  Uruchamiam główny interfejs..."
    Write-Host "==================================================" -ForegroundColor Green
    Start-Sleep -Seconds 3

    # Uruchomienie Twojego głównego interfejsu
    try {
        & "$PSScriptRoot\interfejs.ps1"
    } catch {
        Write-Host "KRYTYCZNY BŁĄD: Nie można uruchomić pliku interfejs.ps1!" -ForegroundColor Red
        Write-Host $_.Exception.Message
        Read-Host "Wciśnij Enter, aby zakończyć."
    }

} else {
    Write-Host "`n==================================================" -ForegroundColor Red
    Write-Host "  AUDYT ZAKOŃCZONY NIEPOWODZENIEM!"
    Write-Host "  Twój system nie spełnia minimalnych wymagań bezpieczeństwa tego narzędzia."
    Write-Host "  Szczegóły poniżej:"
    Write-Host "--------------------------------------------------" -ForegroundColor Red
    
    foreach ($blad in $raportBledow) {
        Write-Host $blad -ForegroundColor Yellow
    }

    Write-Host "`nProszę włączyć powyższe funkcje i spróbować ponownie." -ForegroundColor Red
    Read-Host "Wciśnij Enter, aby zakończyć."
}
