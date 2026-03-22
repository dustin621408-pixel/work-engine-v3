Write-Host "=== FAILURE PATTERNS ==="
Get-Content "C:\WorkEngine\library\failure_patterns.txt" | Group-Object | Sort-Object Count -Descending
