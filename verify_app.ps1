$verified = $false

for ($i = 0; $i -lt 15; $i++) {
    try {
        $response = Invoke-RestMethod -Uri "http://localhost:5000/" -TimeoutSec 2

        if ($response.status -eq "success") {
            Write-Output "Application verification successful!"
            Write-Output $response.message
            $verified = $true
            break
        }
    }
    catch {
        Start-Sleep -Seconds 2
    }
}

if (-not $verified) {
    throw "Application verification failed!"
}
