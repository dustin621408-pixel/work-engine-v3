param([string]$jobPath)

if (-not $jobPath -or $jobPath -eq "") {
    Write-Host "[ENGINE] No job path provided."
    exit
}

$jobName = Split-Path $jobPath -Leaf
$steps = Get-Content $jobPath

$isQueued = $jobPath -match "queues\\"

function Resolve-Intents($step) {
    $s = $step.ToLower()
    $intents = @()

    if ($s -match "summary|summarize") { $intents += "summary" }
    if ($s -match "log|record|track") { $intents += "log" }
    if ($s -match "identify|classify") { $intents += "identify" }
    if ($s -match "scan|check") { $intents += "scan" }

    if ($s -match "angry|frustrated|happy|upset|tone|sentiment") {
        $intents += "emotion_analysis"
    }

    if ($s -match "urgent|asap|immediately|critical") {
        $intents += "urgency_detection"
    }

    if ($s -match "fix|resolve|handle|complete|review|update|respond|extract|find|identify|determine|highlight|prioritize|list") {
        $intents += "action_extraction"
    }

    if ($intents.Count -eq 0) {
        $intents += "unknown"
    }

    $intents = $intents | Select-Object -Unique

    if ($intents.Count -gt 1) {
        $intents = $intents | Where-Object { $_ -ne "unknown" }
    }

    return $intents
}

Write-Host "=== GOGO ENGINE V3.2 (STABLE) ==="

$stepNum = 1

foreach ($step in $steps) {

    $intents = Resolve-Intents $step

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    Write-Host "$timestamp | $jobName | STEP $stepNum | INTENTS: $($intents -join ', ')"

    # === PRIORITY ENGINE ===
    $priority = "low"

    if ($intents -contains "urgency_detection" -and $step -match "urgent|asap|critical") {
        $priority = "high"
    }
    elseif ($intents -contains "emotion_analysis" -and $step -match "angry|frustrated") {
        $priority = "medium"
    }

    Write-Host "[ENGINE] Priority level: $priority"

    # === ROUTING (ONLY IF NOT QUEUED) ===
    if (-not $isQueued) {

        $destination = ""

        if ($priority -eq "high") {
            $destination = "C:\WorkEngine\queues\urgent\$jobName"
        }
        elseif ($priority -eq "medium") {
            $destination = "C:\WorkEngine\queues\normal\$jobName"
        }
        else {
            $destination = "C:\WorkEngine\queues\backlog\$jobName"
        }

        if ($jobPath -ne $destination) {
            Copy-Item $jobPath $destination -Force
            Write-Host "[ENGINE] Routed to: $destination"
        }
    }
    else {
        Write-Host "[ENGINE] Skipping routing (already in queue)"
    }

    $stepNum++
}

Write-Host "=== ENGINE COMPLETE ==="

