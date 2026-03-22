Write-Host "BACKLOG WORKER STARTED..." -ForegroundColor Cyan

$queue = "C:\WorkEngine\queues\backlog\"
$completed = "C:\WorkEngine\queues\completed\"
$logs = "C:\WorkEngine\logs\"

New-Item -ItemType Directory -Force -Path $logs | Out-Null

while ($true) {
    $jobs = Get-ChildItem $queue -Filter *.txt -ErrorAction SilentlyContinue

    foreach ($job in $jobs) {
        Write-Host "Processing BACKLOG job: $($job.Name)" -ForegroundColor Magenta

        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logLine = "$timestamp | BACKLOG | $($job.Name)"
        Add-Content "$logs\execution.log" $logLine

        # slower execution (simulated delay)
        Start-Sleep -Seconds 10

        $dest = Join-Path $completed $job.Name
        Move-Item $job.FullName $dest -Force

        Write-Host "Completed (BACKLOG): $($job.Name)" -ForegroundColor Green
    }

    Start-Sleep -Seconds 10
}
