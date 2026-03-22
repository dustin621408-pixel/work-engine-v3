param([string]$jobPath)

# =========================
# INTENT RESOLVER (TUNED)
# =========================
function Resolve-Intents($step) {
    $s = $step.ToLower()
    $intents = @()

    if ($s -match "scan|look|check") { $intents += "scan" }
    if ($s -match "identify|type|classify") { $intents += "identify" }
    if ($s -match "report|output report") { $intents += "report" }
    if ($s -match "folder|move|organize|sort files|group") { $intents += "organize" }
    if ($s -match "summary|summarize") { $intents += "summary" }
    if ($s -match "log|record|track") { $intents += "log" }
    if ($s -match "rename|rename files|rename all") { $intents += "rename" }
    if ($s -match "duplicate|duplicates|copy check") { $intents += "duplicates" }

    # Fallback
    if ($intents.Count -eq 0) {
        $intents += "unknown"
    }

    return $intents
}

# =========================
# MEMORY LOAD (SAFE)
# =========================
$memoryPath = "C:\WorkEngine\memory\intent_stats.json"

if (!(Test-Path "C:\WorkEngine\memory")) {
    New-Item -ItemType Directory -Path "C:\WorkEngine\memory" | Out-Null
}

if (Test-Path $memoryPath) {
    $raw = Get-Content $memoryPath -Raw | ConvertFrom-Json
    $memory = @{}
    $raw.PSObject.Properties | ForEach-Object {
        $memory[$_.Name] = $_.Value
    }
} else {
    $memory = @{}
}

# =========================
# JOB PARSER
# =========================
function Parse-Job($lines) {
    $parsed = @()
    $stepNum = 1

    foreach ($line in $lines) {
        $intents = Resolve-Intents $line

        $parsed += [PSCustomObject]@{
            StepNumber = $stepNum
            RawText = $line
            Intents = $intents
        }

        $stepNum++
    }

    return $parsed
}

# =========================
# EXECUTION
# =========================
$jobName = Split-Path $jobPath -Leaf
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "C:\WorkEngine\output\results_log.txt"

Write-Host "=== GOGO ENGINE V3.1 (INTENT TUNED) ==="

$steps = Parse-Job (Get-Content $jobPath)

foreach ($step in $steps) {

    Write-Host "$timestamp | $jobName | STEP $($step.StepNumber) | INTENTS: $($step.Intents -join ', ')"

    $duplicatesFound = $false

    foreach ($intent in $step.Intents) {

        # MEMORY UPDATE
        if ($memory.ContainsKey($intent)) {
            $memory[$intent]++
        } else {
            $memory[$intent] = 1
        }

        switch ($intent) {

            "organize" {
                $files = Get-ChildItem "C:\WorkEngine\intake" -File
                foreach ($f in $files) {
                    $ext = $f.Extension.Replace(".", "")
                    if (!$ext) { continue }

                    $folder = "C:\WorkEngine\intake\$ext"
                    if (!(Test-Path $folder)) {
                        New-Item -ItemType Directory $folder | Out-Null
                    }

                    Move-Item $f.FullName "$folder\$($f.Name)" -Force
                }
            }

            "rename" {
                $files = Get-ChildItem "C:\WorkEngine\intake" -File
                $i = 1
                foreach ($f in $files) {
                    Rename-Item $f.FullName "renamed_$i$($f.Extension)"
                    $i++
                }
            }

            "duplicates" {
                $files = Get-ChildItem "C:\WorkEngine\intake" -File
                $hashes = @{}

                foreach ($f in $files) {
                    $h = (Get-FileHash $f.FullName -Algorithm MD5).Hash
                    if ($hashes[$h]) {
                        $duplicatesFound = $true
                    } else {
                        $hashes[$h] = $true
                    }
                }
            }

            "log" {
                "$timestamp | $jobName | LOGGED" | Add-Content $logPath
            }

            "unknown" {

    $unknownPath = "C:\WorkEngine\memory\unknown_intents.json"
    $unknownData = @{}

    if (Test-Path $unknownPath) {
        $unknownData = Get-Content $unknownPath | ConvertFrom-Json
    }

    $key = $step.RawText.Trim()

    if ($unknownData.ContainsKey($key)) {
        $unknownData[$key] += 1
    } else {
        $unknownData[$key] = 1
    }

    $unknownData | ConvertTo-Json | Set-Content $unknownPath -Encoding UTF8

    Write-Host "$timestamp | $jobName | UNKNOWN INTENT CAPTURED: $key"
}
        }
    }

    if ($duplicatesFound -and $step.Intents -contains "log") {
        "$timestamp | $jobName | CONDITIONAL TRIGGERED" | Add-Content $logPath
    }
}

# SAVE MEMORY
$memory | ConvertTo-Json | Set-Content $memoryPath

Write-Host "=== ENGINE V3.1 COMPLETE ==="




