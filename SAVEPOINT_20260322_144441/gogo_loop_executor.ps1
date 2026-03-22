Write-Host "ENGINE STARTED..." -ForegroundColor Cyan

$jobPath = $args[0]

if (-not $jobPath) {
    Write-Host "No job path received." -ForegroundColor Red
    exit
}

if (-not (Test-Path $jobPath)) {
    Write-Host "Job not found." -ForegroundColor Red
    exit
}

$content = Get-Content $jobPath -Raw

# === INTENT DETECTION ===
$priority = "low"

if ($content -match "urgent|immediately|asap") {
    $priority = "high"
}
elseif ($content -match "important|soon") {
    $priority = "medium"
}

# === ROUTING ===
switch ($priority) {
    "high"   { $destination = "C:\WorkEngine\queues\urgent\" }
    "medium" { $destination = "C:\WorkEngine\queues\normal\" }
    default  { $destination = "C:\WorkEngine\queues\backlog\" }
}

$jobName = Split-Path $jobPath -Leaf
$destPath = Join-Path $destination $jobName

Move-Item $jobPath $destPath -Force

Write-Host "ROUTED: $jobName → $priority" -ForegroundColor Green
