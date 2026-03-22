param(
    [string]$TaskText,
    [string]$OutputJobFile
)

Write-Host "=== PLANNER START ==="

# Normalize input
$task = $TaskText.ToLower()

$plan = @()

# ===== RULE-BASED PLANNING =====

if ($task -match "organize" -and $task -match "file") {

    $plan += "1. Scan folder"
    $plan += "2. Identify file types"
    $plan += "3. Create folders by type"
    $plan += "4. Move files into folders"

}
elseif ($task -match "rename") {

    $plan += "1. Scan files"
    $plan += "2. Generate clean names"
    $plan += "3. Rename files"

}
elseif ($task -match "cleanup" -or $task -match "clean") {

    $plan += "1. Scan folder"
    $plan += "2. Remove duplicates"
    $plan += "3. Sort remaining files"

}
else {

    $plan += "1. Review task"
    $plan += "2. Create basic structure"
}

# ===== WRITE JOB FILE =====

$planText = $plan -join "`n"

if (-not $OutputJobFile) {
    Write-Host "ERROR: OutputJobFile is empty"
    exit
}

Write-Host "WRITING TO: $OutputJobFile"

New-Item -ItemType File -Force -Path $OutputJobFile | Out-Null
Set-Content -Path $OutputJobFile -Value $planText

Write-Host "PLAN CREATED:"
Write-Host $planText
Write-Host "=== PLANNER COMPLETE ==="
