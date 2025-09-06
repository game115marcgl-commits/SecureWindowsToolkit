# interfejs.ps1 - Wersja 2.0
# Autor: Marcel, Elbląg 🇵🇱
# Cel: Graficzny interfejs dla SecureWindowsToolkit

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing # Dodajemy, żeby mieć dostęp do kolorów itp.

# --- Główne okno ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "SecureWindowsToolkit by Marcel"
$form.Size = New-Object System.Drawing.Size(400, 300)
$form.StartPosition = "CenterScreen" # Okno pojawi się na środku ekranu
$form.FormBorderStyle = "FixedSingle" # Zablokowanie możliwości zmiany rozmiaru okna
$form.MaximizeBox = $false

# --- Pole tekstowe na logi i komunikaty ---
$outputBox = New-Object System.Windows.Forms.TextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 10)
$outputBox.Size = New-Object System.Drawing.Size(360, 150)
$outputBox.Multiline = $true
$outputBox.ScrollBars = "Vertical"
$outputBox.ReadOnly = $true
$outputBox.Text = "Witaj w SecureWindowsToolkit! Wybierz operację."

# --- Przycisk: Czyszczenie systemu ---
$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "🧹 Wyczyść system"
$btnClean.Location = New-Object System.Drawing.Point(10, 170)
$btnClean.Size = New-Object System.Drawing.Size(175, 40)
$btnClean.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# --- Przycisk: Wyłączanie usług ---
$btnServices = New-Object System.Windows.Forms.Button
$btnServices.Text = "🛑 Wyłącz usługi"
$btnServices.Location = New-Object System.Drawing.Point(195, 170)
$btnServices.Size = New-Object System.Drawing.Size(175, 40)
$btnServices.Font = New-Object System.Drawing.Font("Segoe UI", 10)

# --- Logika przycisków (co się dzieje po kliknięciu) ---

$btnClean.Add_Click({
    $outputBox.Text = "Rozpoczynam czyszczenie systemu... To może chwilę potrwać."
    $form.Refresh() # Odświeżenie okna, żeby zobaczyć komunikat
    
    # Uruchamiamy skrypt w tle i czekamy na jego zakończenie
    $process = Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\czyszczenie_systemu.ps1`"" -Wait -NoNewWindow -PassThru
    
    # Po zakończeniu czytamy log i wyświetlamy go
    $logContent = Get-Content "$env:USERPROFILE\Desktop\log_czyszczenia.txt"
    $outputBox.Text = "CZYSZCZENIE ZAKOŃCZONE!`r`n--- LOG ---`r`n" + ($logContent | Out-String)
})

$btnServices.Add_Click({
    # PAMIĘTAJ: Zmień nazwę pliku z "wyłącz_usługi.ps1" na "wylacz_uslugi.ps1"
    $outputBox.Text = "Uruchamiam skrypt do wyłączania usług..."
    $form.Refresh()
    
    Start-Process powershell.exe -ArgumentList "-ExecutionPolicy Bypass -File `"$PSScriptRoot\wylacz_uslugi.ps1`"" -Verb RunAs # Uruchomienie jako administrator
    
    $outputBox.AppendText("`r`nGotowe! Skrypt został uruchomiony z uprawnieniami administratora.")
})

# --- Dodanie kontrolek do okna ---
$form.Controls.Add($outputBox)
$form.Controls.Add($btnClean)
$form.Controls.Add($btnServices)

# --- Wyświetlenie okna ---
[void]$form.ShowDialog()
