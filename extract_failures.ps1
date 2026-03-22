$logPath = "C:\WorkEngine\logs\execution.log"
$failureFile = "C:\WorkEngine\library\failure_patterns.txt"

New-Item -ItemType Directory -Force -Path "C:\WorkEngine\library" | Out-Null
New-Item -ItemType File -Force -Path $failureFile | Out-Null

$failures = Select-String -Path $logPath -Pattern "NO ACTION MATCHED"

foreach ($f in $failures) {
    $line = $f.Line

    # Extract just the step text
    if ($line -match "NO ACTION MATCHED FOR: (.*)") {
        $step = $matches[1]
        Add-Content -Path $failureFile -Value $step
    }
}

Write-Host "FAILURES EXTRACTED FROM LOG"
