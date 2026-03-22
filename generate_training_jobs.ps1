$jobs = @()

# ===== JOB 1 =====
$jobs += @"
1. Scan folder
2. Identify file types
"@

# ===== JOB 2 =====
$jobs += @"
1. Scan folder
2. Identify file types
3. Create folders by type
4. Move files into folders
"@

# ===== JOB 3 =====
$jobs += @"
1. Scan folder
2. Identify file types
3. Generate file summary
"@

# ===== JOB 4 =====
$jobs += @"
1. Create intake folder
2. Prepare file
3. Generate summary
"@

# ===== JOB 5 =====
$jobs += @"
1. Scan folder
2. Identify file types
3. Log results
"@

# ===== DROP JOBS INTO SYSTEM =====
$i = 1
foreach ($job in $jobs) {

    $jobPath = "C:\WorkEngine\jobs\active\job_training_$i.txt"

    Set-Content -Path $jobPath -Value $job -Encoding UTF8

    Write-Host "CREATED JOB: job_training_$i.txt"

    Start-Sleep -Milliseconds 300

    $i++
}
