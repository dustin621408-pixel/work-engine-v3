param($jobPath)

if (-not (Test-Path $jobPath)) { exit }

$content = Get-Content $jobPath -Raw
$outputFolder = "C:\WorkEngine\output\"
New-Item -ItemType Directory -Force -Path $outputFolder | Out-Null

$actions = @()

# === STATE CHECK ===
$statePath = "C:\WorkEngine\state\system_status.txt"
$systemState = "UNKNOWN"

if (Test-Path $statePath) {
    $systemState = Get-Content $statePath -Raw
}

Write-Host "SYSTEM STATE: $systemState" -ForegroundColor DarkCyan

# === SIGNALS ===
$hasFixSignal = $content -match "fix|resolve|repair|issue|problem|bug|broken|error"
$hasAnalyzeSignal = $content -match "analyze|review|look at|check|investigate|see if"
$hasRespondSignal = $content -match "respond|reply|client|customer|explain|email"
$isConditional = $content -match "if|if needed|if exists|otherwise|else"

# === CONDITIONAL DISCIPLINE ===
if ($isConditional) {

    Write-Host "CONDITIONAL LOGIC DETECTED" -ForegroundColor Yellow

    if ($systemState -match "BROKEN") {
        if ($hasFixSignal) {
            $actions += "take_action"
        } else {
            $actions += "analyze_text"
        }
    }
    else {
        # HARD BLOCK — NO ACTION WHEN OK
        $actions += "analyze_text"
    }

    if ($hasRespondSignal) {
        $actions += "generate_response"
    }

}
else {

    # === NON-CONDITIONAL DISCIPLINE ===

    if ($hasAnalyzeSignal) {
        $actions += "analyze_text"
    }

    if ($hasRespondSignal) {
        $actions += "generate_response"
    }

    # 🔒 HARD RULE: ONLY FIX IF BROKEN
    if ($hasFixSignal -and $systemState -match "BROKEN") {
        $actions += "take_action"
    }

}

# === SAFETY ===
if ($actions.Count -eq 0) {
    $actions += "analyze_text"
}

Write-Host "ACTIONS DETECTED: $($actions -join ', ')" -ForegroundColor Cyan

foreach ($action in $actions) {

    switch ($action) {

        "analyze_text" {
            "Analysis: $($content.Length)" | Set-Content "$outputFolder\analysis_$((Get-Random)).txt"
        }

        "generate_response" {
            "Response generated" | Set-Content "$outputFolder\response_$((Get-Random)).txt"
        }

        "take_action" {
            "Action taken because system is VERIFIED BROKEN" | Set-Content "$outputFolder\action_$((Get-Random)).txt"
        }
    }
}


try {
} catch {
    Write-Host "Deliverable engine failed" -ForegroundColor Red
}


# === DELIVERABLE HOOK ===
try {
    powershell C:\WorkEngine\deliverable_engine.ps1 "$jobName" "$content"
} catch {
    Write-Host "Deliverable engine failed" -ForegroundColor Red
}
