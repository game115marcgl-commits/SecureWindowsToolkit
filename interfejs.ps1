Add-Type -AssemblyName System.Windows.Forms

$form = New-Object System.Windows.Forms.Form
$form.Text = "SecureWindowsToolkit by Marcel"
$form.Size = New-Object System.Drawing.Size(300,200)

$btnClean = New-Object System.Windows.Forms.Button
$btnClean.Text = "🧹 Wyczyść system"
$btnClean.Location = New-Object System.Drawing.Point(50,30)
$btnClean.Size = New-Object System.Drawing.Size(200,30)
$btnClean.Add_Click({ Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File czyszczenie_systemu.ps1" })

$btnServices = New-Object System.Windows.Forms.Button
$btnServices.Text = "🛑 Wyłącz usługi"
$btnServices.Location = New-Object System.Drawing.Point(50,80)
$btnServices.Size = New-Object System.Drawing.Size(200,30)
$btnServices.Add_Click({ Start-Process "powershell.exe" -ArgumentList "-ExecutionPolicy Bypass -File wyłącz_usługi.ps1" })

$form.Controls.Add($btnClean)
$form.Controls.Add($btnServices)
$form.ShowDialog()
