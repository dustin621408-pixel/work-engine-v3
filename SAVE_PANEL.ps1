Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "PulseCore Control Panel"
$form.Size = New-Object System.Drawing.Size(400,200)
$form.StartPosition = "CenterScreen"

$button = New-Object System.Windows.Forms.Button
$button.Text = "SAVE SYSTEM STATE"
$button.Size = New-Object System.Drawing.Size(200,50)
$button.Location = New-Object System.Drawing.Point(90,50)

$button.Add_Click({

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $savePath = "C:\WorkEngine\SAVEPOINT_$timestamp"

    New-Item -ItemType Directory -Path $savePath | Out-Null

    Copy-Item "C:\WorkEngine\gogo_loop_executor.ps1" "$savePath\" -ErrorAction SilentlyContinue
    Copy-Item "C:\WorkEngine\auto_runner.ps1" "$savePath\" -ErrorAction SilentlyContinue
    Copy-Item "C:\WorkEngine\generate_batch.ps1" "$savePath\" -ErrorAction SilentlyContinue
    Copy-Item "C:\WorkEngine\unknown_watcher.ps1" "$savePath\" -ErrorAction SilentlyContinue

    if (Test-Path "C:\WorkEngine\memory") {
        Copy-Item "C:\WorkEngine\memory" "$savePath\memory" -Recurse -ErrorAction SilentlyContinue
    }

    Set-Clipboard -Value $savePath

    Start-Process $savePath

    [System.Windows.Forms.MessageBox]::Show(
        "System saved successfully.`n`nPath copied to clipboard:`n$savePath",
        "SAVE COMPLETE"
    )
})

$form.Controls.Add($button)
$form.Topmost = $true
$form.Add_Shown({$form.Activate()})
[void]$form.ShowDialog()
