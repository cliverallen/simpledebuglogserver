$Password = ([char[]]([char]33..[char]95) + ([char[]]([char]97..[char]126)) + 0..9 | sort-object {Get-Random})[0..8] -join ''
((Get-Content -path $PWD/pwsh/web-pages-docker.ps1 -Raw) -replace '###PASS###',$Password) | Set-Content -Path ./pwsh/web-pages-docker.ps1
Write-Host "Password set to " $Password