# backup_service.ps1 — simple backup + log
$Source = "C:\Users\LENOVO\Documents\Important"
$DestRoot = "C:\Users\LENOVO\Deltasec\Backups"
$TimeStamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Dest = Join-Path $DestRoot "Backup_$TimeStamp"

# Pastikan folder tujuan ada
if (-not (Test-Path $DestRoot)) {
    New-Item -ItemType Directory -Path $DestRoot | Out-Null
}

# Lakukan backup
try {
    Copy-Item -Path $Source -Destination $Dest -Recurse -Force -ErrorAction Stop
    $status = "SUCCESS"
} catch {
    $status = "ERROR: $($_.Exception.Message)"
}

# Tuliskan log
$LogLine = "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Backup: Source='$Source' Dest='$Dest' Status=$status"
$LogFile = "C:\Users\LENOVO\Deltasec\Week1\backup_log.txt"
$LogLine | Out-File -FilePath $LogFile -Append -Encoding UTF8

Write-Host $LogLine
# --- Verification section ---
$restoredFile = "C:\Users\LENOVO\Deltasec\RestoreTest\contoh_restored.txt"
$sourceFile = "C:\Users\LENOVO\Documents\Important\contoh.txt"

# Pastikan folder restore ada
New-Item -ItemType Directory -Path "C:\Users\LENOVO\Deltasec\RestoreTest" -Force | Out-Null

# Salin file dari backup terbaru ke RestoreTest
$latestBackup = Get-ChildItem "C:\Users\LENOVO\Deltasec\Backups" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Copy-Item "$($latestBackup.FullName)\contoh.txt" -Destination $restoredFile -Force

# Bandingkan isi file asli dan hasil restore
$sourceHash = Get-FileHash $sourceFile
$restoredHash = Get-FileHash $restoredFile

if ($sourceHash.Hash -eq $restoredHash.Hash) {
    $verifyStatus = "VERIFIED: Restore file matches original."
} else {
    $verifyStatus = "FAILED: Restore file does not match original!"
}

# Simpan hasil verifikasi ke log
"[{0}] Verification: {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $verifyStatus | Out-File -FilePath $logFile -Append
Write-Output $verifyStatus
