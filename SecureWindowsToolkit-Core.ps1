# =============================================================================
# SecureWindowsToolkit - Core Functions
# Autor: Marcel, Elbląg 🇵🇱
# =============================================================================

# --- Funkcja do logowania zdarzeń ---
function Write-Log {
    param(
        [string]$Message,
        [string]$LogPath
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LogPath -Value "[$timestamp] $Message"
}


# --- FUNKCJA GŁÓWNA: Czyszczenie Systemu ---
function Start-SystemCleanup {
    $logPath = "$env:USERPROFILE\Desktop\log_czyszczenia.txt"
    Write-Log -Message "ROZPOCZĘTO CZYSZCZENIE SYSTEMU" -LogPath $logPath

    # Czyszczenie folderów tymczasowych
    $tempFolders = @("$env:TEMP", "C:\Windows\Temp")
    foreach ($folder in $tempFolders) {
        if (Test-Path $folder) {
            Write-Log -Message "Czyszczenie folderu: $folder" -LogPath $logPath
            try {
                Remove-Item -Path "$folder\*" -Recurse -Force -ErrorAction Stop
            }
            catch {
                Write-Log -Message "BŁĄD przy czyszczeniu $folder : $($_.Exception.Message)" -LogPath $logPath
            }
        }
    }

    # Opróżnianie kosza
    Write-Log -Message "Opróżnianie kosza" -LogPath $logPath
    try {
        Clear-RecycleBin -Force -ErrorAction Stop
    }
    catch {
        Write-Log -Message "BŁĄD przy opróżnianiu kosza: $($_.Exception.Message)" -LogPath $logPath
    }

    # Czyszczenie folderu Prefetch
    $prefetchPath = "C:\Windows\Prefetch"
    if (Test-Path $prefetchPath) {
        Write-Log -Message "Czyszczenie folderu Prefetch" -LogPath $logPath
        try {
            Remove-Item -Path "$prefetchPath\*" -Force -ErrorAction Stop
        }
        catch {
            Write-Log -Message "BŁĄD przy czyszczeniu Prefetch: $($_.Exception.Message)" -LogPath $logPath
        }
    }

    Write-Log -Message "ZAKOŃCZONO CZYSZCZENIE SYSTEMU" -LogPath $logPath
}


# --- FUNKCJA GŁÓWNA: Wyłączanie Usług ---
function Start-ServiceDisabling {
    $logPath = "$env:USERPROFILE\Desktop\log_uslug.txt"
    Write-Log -Message "ROZPOCZĘTO WYŁĄCZANIE USŁUG" -LogPath $logPath
    
    # Lista nazw systemowych usług do wyłączenia
    $servicesToDisable = @(
        "DiagTrack",       # Connected User Experiences and Telemetry
        "XblGameSave",     # Xbox Live Game Save
        "XboxNetApiSvc",   # Xbox Live Networking Service
        "WMPNetworkSvc",   # Windows Media Player Network Sharing Service
        "RetailDemo",      # Retail Demo Service
        "MapsBroker",      # Downloaded Maps Manager
        "Fax",             # Fax
        "RemoteRegistry"  # Remote Registry
    )

    foreach ($serviceName in $servicesToDisable) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service) {
            try {
                Set-Service -Name $serviceName -StartupType Disabled -ErrorAction Stop
                Stop-Service -Name $serviceName -Force -ErrorAction Stop
                Write-Log -Message "Usługa '$($service.DisplayName)' ($serviceName): WYŁĄCZONA" -LogPath $logPath
            } 
            catch {
                Write-Log -Message "BŁĄD przy wyłączaniu usługi $serviceName: $($_.Exception.Message)" -LogPath $logPath
            }
        } else {
            Write-Log -Message "Usługa $serviceName: NIE ZNALEZIONA" -LogPath $logPath
        }
    }

    Write-Log -Message "ZAKOŃCZONO WYŁĄCZANIE USŁUG" -LogPath $logPath
}
