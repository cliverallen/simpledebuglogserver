$currentPath = Get-Location
$Password = ([char[]]([char]65..[char]90) + [char[]]([char]97..[char]122) + 0..9 | sort-object {Get-Random})[0..8] -join ''
$authToken =  ([char[]]([char]65..[char]90) + [char[]]([char]97..[char]122) + 0..9 | sort-object {Get-Random})[0..100] -join '';
((Get-Content -path $currentPath/pwsh/web-pages-docker.ps1 -Raw) -replace '###PASS###',$Password) | Set-Content -Path ./pwsh/web-pages-docker.ps1
((Get-Content -path $currentPath/pwsh/web-pages-docker.ps1 -Raw) -replace '###TOKEN###',$authToken) | Set-Content -Path ./pwsh/web-pages-docker.ps1
Write-Host "Current dir " $currentPath
Write-Host "Password set to " $Password
Write-Host "Auth token set to " $authToken
Write-Host "##vso[task.setvariable variable=logauthtoken;]$authToken"