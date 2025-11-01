# 🧠 Deltasec Day 4 - Automated Backup Script (Fixed Output)

$source = "C:\Users\LENOVO\Documents\Important"
$destRoot = "C:\Users\LENOVO\Deltasec\Backups"
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dest = "$destRoot\Backup_$timestamp"
$logFile = "C:\Users\LENOVO\Deltasec\Week1\Day4\auto_backup_log.txt"

# 🗂️ Buat folder backup baru
Copy-Item $source -Destination $dest -Recurse -Force
$logEntry = "[{0}] Backup done to {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $dest
$logEntry | Tee-Object -FilePath $logFile -Append
Write-Host $logEntry

# ✅ Verifikasi otomatis
$original = Get-Content "$source\contoh.txt"
$restored = Get-Content "$dest\contoh.txt"

if ($original -eq $restored) {
    $verify = "[{0}] Verification: OK ✅" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} else {
    $verify = "[{0}] Verification: FAILED ❌" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
}

$verify | Tee-Object -FilePath $logFile -Append
Write-Host $verify
