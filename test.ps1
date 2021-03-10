# $var = @{}
# $var.Add("myindex","myvalue")
# $var.Add("myindextwo","myvaluetwo")
# foreach ($a in $var.GetEnumerator()) {
#     Write-host $a.key $a.value
# }
# $var.GetType()

# $myvar = @{}
# $now = Get-Date
# $alog = @{Date = $now; Log = "blahblah";}
# $alog.Category = "Info"
# $myvar += $alog
# $now = Get-Date
# $alog = @{Date = $now; Log = "boohoo";}
# $alog.Category = "Info"
# $myvar += $alog
# # $now = Get-Date
# # $myvar = $myvar + @{Date = $now; Category = "Info"; Log = "boooooo"}
# # $now = Get-Date
# # $myvar = $myvar + @{Date = $now; Category = "Info"; Log = "buybuybuy"}

# $myvar
# $myvar.GetType()
# $myvar.Count
class Logdata {
    [string]$Timestamp
    [string]$Data
    [string]$Category

}
$arr = @()
$data = [Logdata]::new()
$data.Category = "Info"
$data.Data = "blah"
$data.Timestamp = Get-Date
$arr += $data
# $arr
Pause(100)
$data = [Logdata]::new()
$data.Category = "Info"
$data.Data = "blah"
$data.Timestamp = Get-Date
$arr += $data
[array]::Reverse($arr)
$arr
# $arr | Sort-Object -Property $arr.Timestamp -Descending
foreach($a in [array]::Reverse($arr)) {
    $a.Timestamp
    $a.Category
}

$(
    #foreach ($a in $data.datalog.logdata.GetEnumerator() | Sort-Object -Property key -Descending ) {
    #   "<li>" + $a.key + " " + $a.value + "</li>";
    #}
)