param(
    [string]$Step
)

$failureDir = "C:\WorkEngine\library"
$failureFile = "$failureDir\failure_patterns.txt"

New-Item -ItemType Directory -Force -Path $failureDir | Out-Null
New-Item -ItemType File -Force -Path $failureFile | Out-Null

Add-Content -Path $failureFile -Value $Step
