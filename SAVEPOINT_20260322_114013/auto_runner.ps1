while ($true) {

    $job = Get-ChildItem "C:\WorkEngine\jobs\active\*.txt" | Select-Object -First 1

    if ($job -and $job.FullName) {

        Write-Host "FOUND JOB: $($job.Name)"

        powershell -ExecutionPolicy Bypass -File "C:\WorkEngine\gogo_loop_executor.ps1" -jobPath $job.FullName

        # Move processed job
        $processedPath = "C:\WorkEngine\jobs\processed"

        if (!(Test-Path $processedPath)) {
            New-Item -ItemType Directory -Path $processedPath | Out-Null
        }

        $destination = Join-Path $processedPath $job.Name
        Move-Item -Path $job.FullName -Destination $destination -Force

        Write-Host "MOVED TO PROCESSED: $($job.Name)"

    } else {

        Write-Host "No jobs found... waiting"

    }

    Start-Sleep -Seconds 3
}
