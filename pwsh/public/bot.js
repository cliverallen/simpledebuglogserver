(function (window, document) {

// document.getElementById("startupdate").onclick = startUpdate;
// document.getElementById("stopupdate").onclick = cancelUpdate;
document.getElementById("manualrefresh").onclick = update;
document.getElementById("autostarttoggle").onclick = toggleAutorefresh;

document.getElementById("button-success").onclick = function setCategory() {document.getElementById("category").textContent = 'success';update();sessionStorage.logFilter = document.getElementById("category").textContent;};
document.getElementById("button-info").onclick = function setCategory() {document.getElementById("category").textContent = 'info';update();sessionStorage.logFilter = document.getElementById("category").textContent;};
document.getElementById("button-warning").onclick = function setCategory() {document.getElementById("category").textContent = 'warning';update();sessionStorage.logFilter = document.getElementById("category").textContent;};
document.getElementById("button-error").onclick = function setCategory() {document.getElementById("category").textContent = 'error';update();sessionStorage.logFilter = document.getElementById("category").textContent;};
document.getElementById("button-clear").onclick = function setCategory() {document.getElementById("category").textContent = '';update();sessionStorage.logFilter = document.getElementById("category").textContent;};
document.getElementById("loglines").onclick = function setLogLines() {sessionStorage.logLines = document.getElementById("loglines").value;};
// document.getElementById("loglines").onchange = linesUpdate;
// if(!sessionStorage.updateTimer) {
//     console.log('Setting Inital Timer');
//     sessionStorage.updateTimer = 0;
// } else {
//     toggleAutorefresh();
// }
// $query = "lines=" + document.getElementById("loglines").value;
if(!sessionStorage.logLines) {
    sessionStorage.logLines = document.getElementById("loglines").value;
} else {
    document.getElementById("loglines").value = sessionStorage.logLines;
}

if(!sessionStorage.logFilter) {
    sessionStorage.logFilter = document.getElementById("category").textContent;
} else {
    document.getElementById("category").textContent = sessionStorage.logFilter;
}
if(!sessionStorage.updateTimer) {
    sessionStorage.updateTimer = 0;
}
function toggleAutorefresh() {
    
    if(sessionStorage.updateTimer == 0) {
        update();
        sessionStorage.updateTimer = setInterval(update,5000);
        document.getElementById("autostarttoggle").textContent = 'Toggle Auto Refresh Off'
    } else {
        clearInterval(sessionStorage.updateTimer);
        sessionStorage.updateTimer = 0;
        document.getElementById("autostarttoggle").textContent = 'Toggle Auto Refresh On'
    }
}

function linesUpdate() {
    $query = "lines=" + document.getElementById("loglines").value;
}


function update() {
    $query = "lines=" + document.getElementById("loglines").value;
    $category = "category=" + document.getElementById("category").textContent;
    $url = "/ajax?" + $query + "&" + $category;
    $('#logdata').load($url);
    //$('#div1').load("index.jsp");
}

function cancelUpdate() {
    document.getElementById("startupdate").disabled = false;
    document.getElementById("stopupdate").disabled = true;
    clearInterval(sessionStorage.updateTimer);
}

function startUpdate() {
    document.getElementById("startupdate").disabled = true;
    document.getElementById("stopupdate").disabled = false;
    update(); //to run on page load
    sessionStorage.updateTimer = setInterval(update,5000);
}


    // update(); //to run on page load
    // sessionStorage.updateTimer = setInterval(update,1000);
    // startUpdate();
}(this, this.document));