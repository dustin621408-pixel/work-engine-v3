$jobs = @()

# CORE (repeat these more often)
$jobs += "1. Scan folder`n2. Identify file types"
$jobs += "1. Scan folder`n2. Identify file types`n3. Create report"
$jobs += "1. Scan folder`n2. Identify file types`n3. Create folders by type`n4. Move files into folders"
$jobs += "1. Scan folder`n2. Identify file types`n3. Create folders by type`n4. Move files into folders"

# VARIATION (learning expansion)
$jobs += "1. Scan folder`n2. Identify file types`n3. Generate file summary"
$jobs += "1. Scan folder`n2. Identify file types`n3. Log results"
$jobs += "1. Scan folder`n2. Identify file types`n3. Rename files"
$jobs += "1. Scan folder`n2. Identify file types`n3. Detect duplicates"
$jobs += "1. Scan folder`n2. Identify file types`n3. Sort by date"
$jobs += "1. Scan folder`n2. Identify file types`n3. Organize output"

# EDGE CASE
$jobs += "1. Do something impossible"

$multiplier = 3

$i = 1

for ($m = 1; $m -le $multiplier; $m++) {
    foreach ($job in $jobs) {
        $path = "C:\WorkEngine\jobs\active\job_batch_$i.txt"
        Set-Content $path $job
        Write-Host "CREATED: job_batch_$i"
        Start-Sleep -Milliseconds 100
        $i++
    }
}
