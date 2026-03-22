Write-Host "AUTO RUNNER STARTED..." -ForegroundColor Cyan

$watch = "C:\WorkEngine\jobs\active\"
$processing = "C:\WorkEngine\jobs\processing\"

# Ensure processing folder exists
New-Item -ItemType Directory -Force -Path $processing | Out-Null

while ($true) {
    $jobs = Get-ChildItem $watch -Filter *.txt -ErrorAction SilentlyContinue

    foreach ($job in $jobs) {
        Write-Host "FOUND JOB: $($job.Name)" -ForegroundColor Yellow

        # === MOVE TO PROCESSING (PREVENT DUPLICATE PICKUP) ===
        $procPath = Join-Path $processing $job.Name
        Move-Item $job.FullName $procPath -Force

        # === SEND TO ENGINE ===
        powershell C:\WorkEngine\gogo_loop_executor.ps1 $procPath

        Write-Host "SENT TO ENGINE: $($job.Name)" -ForegroundColor Gray
    }

    Start-Sleep -Seconds 2
}
