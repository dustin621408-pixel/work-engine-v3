Write-Host "AUTO RUNNER STARTED..." -ForegroundColor Cyan

$watch = "C:\WorkEngine\jobs\active\"

while ($true) {
    $jobs = Get-ChildItem $watch -Filter *.txt -ErrorAction SilentlyContinue

    foreach ($job in $jobs) {
        Write-Host "FOUND JOB: $($job.Name)" -ForegroundColor Yellow

        powershell C:\WorkEngine\gogo_loop_executor.ps1 $job.FullName

        Write-Host "SENT TO ENGINE: $($job.Name)" -ForegroundColor Gray
    }

    Start-Sleep -Seconds 3
}
