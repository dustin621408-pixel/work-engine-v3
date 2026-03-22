Write-Host "ENGINE STARTED..." -ForegroundColor Cyan

$jobPath = $args[0]

if (-not $jobPath) { exit }
if (-not (Test-Path $jobPath)) { exit }

$content = Get-Content $jobPath -Raw

$priority = "low"

# === HARD URGENT ===
if ($content -match "urgent|asap|immediately|critical|fix now|system down|breaking|fail|down") {
    $priority = "high"
}

# === STRONG PROBLEM SIGNALS (PROMOTE TO MEDIUM) ===
elseif ($content -match "issue|problem|error|bug|not working|weird|glitch|crash|refund|complaint|users|customer") {
    $priority = "medium"
}

# === HUMAN + CONTEXT SIGNALS ===
elseif ($content -match "client|customer|waiting|follow-up|deadline|soon|important|meeting") {
    $priority = "medium"
}

# === RELAXED ONLY (STRICT LOW) ===
elseif ($content -match "no rush|when you can|later|not urgent|take your time|whenever") {
    $priority = "low"
}

# === DEFAULT SAFETY NET (NEW) ===
else {
    $priority = "medium"
}

Write-Host "PRIORITY DETECTED: $priority" -ForegroundColor Yellow

switch ($priority) {
    "high"   { $destination = "C:\WorkEngine\queues\urgent\" }
    "medium" { $destination = "C:\WorkEngine\queues\normal\" }
    default  { $destination = "C:\WorkEngine\queues\backlog\" }
}

$jobName = Split-Path $jobPath -Leaf
$destPath = Join-Path $destination $jobName

Move-Item $jobPath $destPath -Force

Write-Host "ROUTED: $jobName → $priority" -ForegroundColor Green
