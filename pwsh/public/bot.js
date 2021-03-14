(function (window, document) {

// document.getElementById("startupdate").onclick = startUpdate;
// document.getElementById("stopupdate").onclick = cancelUpdate;
document.getElementById("manualrefresh").onclick = update;
document.getElementById("autostarttoggle").onclick = toggleAutorefresh;

document.getElementById("button-success").onclick = function setCategory() {document.getElementById("category").textContent = 'success';update();};
document.getElementById("button-info").onclick = function setCategory() {document.getElementById("category").textContent = 'info';update();};
document.getElementById("button-warning").onclick = function setCategory() {document.getElementById("category").textContent = 'warning';update();};
document.getElementById("button-error").onclick = function setCategory() {document.getElementById("category").textContent = 'error';update();};
document.getElementById("button-clear").onclick = function setCategory() {document.getElementById("category").textContent = '';update();};
// document.getElementById("loglines").onchange = linesUpdate;
if(!sessionStorage.updateTimer) {
    console.log('Setting Inital Timer');
    sessionStorage.updateTimer = 0;
} else {
    toggleAutorefresh();
}
// $query = "lines=" + document.getElementById("loglines").value;

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

// function setCategory(category) {
//     $filter = "category=" + category
// }

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