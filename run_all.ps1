Write-Host "WORK ENGINE UNIFIED CONSOLE STARTED" -ForegroundColor Green

# Clear old jobs
Get-Job | Remove-Job -Force -ErrorAction SilentlyContinue

# Start each component ONCE
Start-Job -Name "AutoRunner" { powershell C:\WorkEngine\auto_runner.ps1 }
Start-Job -Name "UrgentWorker" { powershell C:\WorkEngine\urgent_worker.ps1 }
Start-Job -Name "NormalWorker" { powershell C:\WorkEngine\normal_worker.ps1 }
Start-Job -Name "BacklogWorker" { powershell C:\WorkEngine\backlog_worker.ps1 }

Write-Host "All components started cleanly..." -ForegroundColor Cyan

while ($true) {
    $jobs = Get-Job

    foreach ($job in $jobs) {
        Receive-Job -Job $job -ErrorAction SilentlyContinue
    }

    Start-Sleep -Seconds 2
}
