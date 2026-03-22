Write-Host "[URGENT WORKER] Started..."

while ($true) {

    $jobs = Get-ChildItem "C:\WorkEngine\queues\urgent" -Filter *.txt

    foreach ($job in $jobs) {

        Write-Host "[URGENT WORKER] Processing $($job.Name)"

        $content = Get-Content $job.FullName

        foreach ($line in $content) {

            if ($line -match "fix|resolve|handle") {
                Write-Host "[WORKER] Action: Resolve issue"
            }

            if ($line -match "angry|frustrated") {
                Write-Host "[WORKER] Emotion detected"
            }

            if ($line -match "urgent|asap|immediately") {
                Write-Host "[WORKER] Urgency detected"
            }
        }

        Move-Item $job.FullName "C:\WorkEngine\queues\completed\$($job.Name)" -Force

        Write-Host "[URGENT WORKER] Completed $($job.Name)"
    }

    Start-Sleep -Seconds 2
}
