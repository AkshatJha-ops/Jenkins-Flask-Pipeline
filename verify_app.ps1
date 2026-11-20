$python = Join-Path $PSScriptRoot "venv\Scripts\python.exe"
$app = Join-Path $PSScriptRoot "deploy\app.py"

$p = Start-Process -FilePath $python -ArgumentList "-u", $app -PassThru -WindowStyle Hidden

try {
    $verified = $false

    for ($i = 0; $i -lt 15; $i++) {
        Start-Sleep -Seconds 2

        try {
            $response = Invoke-RestMethod "http://localhost:5000/" -TimeoutSec 2

            if ($response.status -eq "success") {
                Write-Output "Application verification successful!"
                Write-Output $response.message
                $verified = $true
                break
            }
        }
        catch {}
    }

    if (-not $verified) {
        throw "Application verification failed!"
    }
}
finally {
    Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue
}
