$python = Join-Path $PSScriptRoot "venv\Scripts\python.exe"

if (Test-Path (Join-Path $PSScriptRoot "app.pid")) {
    $oldPid = Get-Content (Join-Path $PSScriptRoot "app.pid")
    Stop-Process -Id $oldPid -Force -ErrorAction SilentlyContinue
}

$p = Start-Process -FilePath $python -ArgumentList "deploy\app.py" -WorkingDirectory $PSScriptRoot -PassThru -WindowStyle Hidden

Set-Content (Join-Path $PSScriptRoot "app.pid") $p.Id
Write-Output "Flask application started. PID: $($p.Id)"
