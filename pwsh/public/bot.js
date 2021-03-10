document.getElementById("startupdate").onclick = startUpdate;
document.getElementById("stopupdate").onclick = cancelUpdate;
document.getElementById("loglines").onchange = linesUpdate;

$updateTimer = 0;
$query = "lines=" + document.getElementById("loglines").value

function linesUpdate() {
    $query = "lines=" + document.getElementById("loglines").value
}

function update() {
    $url = "/ajax?" + $query
    $('#logdata').load($url);
    //$('#div1').load("index.jsp");
};

function cancelUpdate() {
    document.getElementById("startupdate").disabled = false;
    document.getElementById("stopupdate").disabled = true;
    clearInterval($updateTimer);
}

function startUpdate() {
    document.getElementById("startupdate").disabled = true;
    document.getElementById("stopupdate").disabled = false;
    update(); //to run on page load
    $updateTimer = setInterval(update,1000);
}

$(function() {
    // update(); //to run on page load
    // $updateTimer = setInterval(update,1000);
    startUpdate();
});