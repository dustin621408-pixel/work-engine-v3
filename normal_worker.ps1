Write-Host "NORMAL WORKER (INTELLIGENT) STARTED..." -ForegroundColor Cyan

$queue = "C:\WorkEngine\queues\normal\"
$completed = "C:\WorkEngine\queues\completed\"

while ($true) {
    $jobs = Get-ChildItem $queue -Filter *.txt -ErrorAction SilentlyContinue

    foreach ($job in $jobs) {
        Write-Host "Processing NORMAL job: $($job.Name)" -ForegroundColor Yellow

        # === CALL EXECUTION ENGINE ===
        powershell C:\WorkEngine\execution_engine.ps1 $job.FullName

        # === COMPLETE ===
        $dest = Join-Path $completed $job.Name
        Move-Item $job.FullName $dest -Force

        Write-Host "Completed: $($job.Name)" -ForegroundColor Green
    }

    Start-Sleep -Seconds 5
}
