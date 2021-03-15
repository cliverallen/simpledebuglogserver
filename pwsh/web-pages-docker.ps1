Import-Module /usr/local/share/powershell/Modules/Pode/Pode.psm1 -Force -ErrorAction Stop
class Logdata {
    [string]$Timestamp
    [string]$Data
    [string]$Category

}
# create a server, and start listening on port 8085
Start-PodeServer -Threads 2 {

    # listen on *:8085
    Add-PodeEndpoint -Address * -Port 8080 -Protocol Http
    Write-Host "Up and running:)"
    # set view engine to pode renderer
    Set-PodeViewEngine -Type Pode

    # enable error logging
    New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging

    # setup session details
    Enable-PodeSessionMiddleware -Secret 'schwifty' -Duration 3600 -Extend

    # setup form auth (<form> in HTML)
    New-PodeAuthScheme -Form | Add-PodeAuth -Name 'Login' -FailureUrl '/login' -SuccessUrl '/' -ScriptBlock {
        param($username, $password)

        # here you'd check a real user storage, this is just for example
        if ($username -eq 'logmon' -and $password -eq '###PASS###') {
            # /usr/src/app/clivebot.ps1 "User $username has logged in"
            return @{
                User = @{
                    ID ='LOG001'
                    Name = 'Logmon'
                    Type = 'Human'
                }
            }
        } #else {
        #     /usr/src/app/clivebot.ps1 "Someone tried to hack us with $username and $password"
        # }

        return @{ Message = 'Invalid details supplied' }
    }
    # Set-PodeState -Name 'hash' -Value @{ 'logdata' = @{}; } | Out-Null
    Set-PodeState -Name 'hash' -Value @{ 'logdata' = @(); } | Out-Null
    Set-PodeState -Name 'settings' -Value @{} | Out-Null
    Restore-PodeState -Path './settings.json'
    # Set-PodeState -Name 'hash' -Value @() | Out-Null
    # API Loging Route
    Add-PodeRoute -Method Get -Path '/api/addlog' -ScriptBlock {
        Lock-PodeObject -Object $WebEvent.Lockable {
            $settings = (Get-PodeState -Name 'settings')
            $bearertoken = Get-PodeHeader -Name 'Authorization'
            $savedtoken = "Bearer " + $settings.token
            Write-Host "Token received: " $bearertoken
            Write-Host "Token required: " $settings.usetoken
            if($settings.usetoken -eq "on" -and $savedtoken -ne $bearertoken) {
                Write-Host "Client not authenticated"
                exit;
            }
            # attempt to get the hashtable from the state
            $hash = (Get-PodeState -Name 'hash')

            # add a random number
            $now=Get-Date
            # $hash.logdata.Add($now,$WebEvent.Query['log'])
            $data = [Logdata]::new()
            $data.Category = $WebEvent.Query['category']
            $data.Data = $WebEvent.Query['log']
            $data.Timestamp = $now
            $localCopy = $hash.logdata.Clone()
            $localCopy += $data
            if($localCopy.Count -gt 500) {
                $hash.logdata = $localCopy[1..500]    
            } else {
                $hash.logdata = $localCopy
            }
            # $hash.logdata += $data

            
            # Write-Host "Data " $hash
            # save the state to file
            # Save-PodeState -Path './state.json'
        }
        # Add-PodeFlashMessage -Name 'debugqueue' -Message 'test'
        # Add-PodeFlashMessage -Name 'debugqueue' -Message $log
    }
    # API Getlogs Route
    Add-PodeRoute -Method Get -Path '/api/getlog' -ScriptBlock {

        Lock-PodeObject -Object $WebEvent.Lockable {

            # get the hashtable from the state and return it
            $hash = (Get-PodeState -Name 'hash')
            Write-Host $hash
            Write-PodeJsonResponse -Value $hash.logdata
        }
    }
    # home page:
    # redirects to login page if not authenticated
    # Add-PodeRoute -Method Get -Path '/' -Authentication Login -ScriptBlock {
    Add-PodeRoute -Method Get -Path '/' -Authentication Login -ScriptBlock {
        Lock-PodeObject -Object $WebEvent.Lockable {

            # get the hashtable from the state and return it
            $hash = (Get-PodeState -Name 'hash')
            $settings = (Get-PodeState -Name 'settings')
            $WebEvent.Session.Data.Views++
        # Write-PodeViewResponse -Path 'simple' -Data @{ 'numbers' = @(1, 2, 3); }
            Write-PodeViewResponse -Path 'simple' -Data @{ 'datalog' = $hash; 'settings' = $settings; 'showsettings' = $WebEvent.Query['settings']; }
        # Write-PodeViewResponse -Path 'auth-home' -Data @{
        #     Username = $WebEvent.Auth.User.Name
        #     Views = $WebEvent.Session.Data.Views
        # }
        }
    }
    Add-PodeRoute -Method Get -Path '/settings' -Authentication Login -ScriptBlock {
        Lock-PodeObject -Object $WebEvent.Lockable {
            $settings = (Get-PodeState -Name 'settings')
            $WebEvent.Session.Data.Views++
            Write-PodeViewResponse -Path 'settings' -Data @{ 'settings' = $settings; }
        }
    }
    Add-PodeRoute -Method Get -Path '/updatesettings' -Authentication Login -ScriptBlock {
        Lock-PodeObject -Object $WebEvent.Lockable {
            $hash = (Get-PodeState -Name 'hash')
            $settings = (Get-PodeState -Name 'settings')
            $WebEvent.Session.Data.Views++
            $settings.usetoken = $WebEvent.Query['tokenactive']
            $settings.token = $WebEvent.Query['tokencode']
            foreach ($item in $WebEvent.Query) {
                Write-Host $item.key + " " + $item.value
            }
            Write-Host $WebEvent.Query['tokenactive'] $WebEvent.Query['tokencode']
            Save-PodeState -Path './settings.json'
            Write-PodeViewResponse -Path 'simple' -Data @{ 'datalog' = $hash; 'settings' = $settings; 'showsettings' = $WebEvent.Query['settings']; }
            # Write-PodeViewResponse -Path 'settings' -Data @{ 'settings' = $settings; }
        }
    }

    Add-PodeRoute -Method Get -Path '/ajax' -Authentication Login -ScriptBlock {
        Lock-PodeObject -Object $WebEvent.Lockable {

            # get the hashtable from the state and return it
            $hash = (Get-PodeState -Name 'hash')
            $WebEvent.Session.Data.Views++
            Write-PodeViewResponse -Path 'ajaxlog' -Data @{ 'datalog' = $hash; 'lines' = $WebEvent.Query['lines']; 'category' = $WebEvent.Query['category']; }
        }
    }    

    # login page:
    # the login flag set below checks if there is already an authenticated session cookie. If there is, then
    # the user is redirected to the home page. If there is no session then the login page will load without
    # checking user authetication (to prevent a 401 status)
    Add-PodeRoute -Method Get -Path '/login' -Authentication Login -Login -ScriptBlock {
        Write-PodeViewResponse -Path 'auth-login' -FlashMessages
    }

    # login check:
    # this is the endpoint the <form>'s action will invoke. If the user validates then they are set against
    # the session as authenticated, and redirect to the home page. If they fail, then the login page reloads
    Add-PodeRoute -Method Post -Path '/login' -Authentication Login -Login


    # logout check:
    # when the logout button is click, this endpoint is invoked. The logout flag set below informs this call
    # to purge the currently authenticated session, and then redirect back to the login page
    Add-PodeRoute -Method Post -Path '/logout' -Authentication Login -Logout


    # GET request throws fake "500" server error status code
    Add-PodeRoute -Method Get -Path '/error' -ScriptBlock {
        Set-PodeResponseStatus -Code 500
    }


}
