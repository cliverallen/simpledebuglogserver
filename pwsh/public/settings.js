(function (window, document) {

    document.getElementById("showToken").onclick = showToken;
    document.getElementById("updateToken").onclick = updateToken;
    
    function updateToken() {
        var status = ""
        if(document.getElementById("tokenactive").checked) {
            status = "on"
        }
        var query = "tokenactive=" + status + "&tokencode=" + document.getElementById("tokenCode").value;
        $url = "/updatesettings?" + query;
        $('#fake').load($url);
        //var jqxhr = $.ajax(url);
        // const Http = new XMLHttpRequest();
        // setTimeout(() => {  console.log("World!"); }, 500);
        // const url='https://jsonplaceholder.typicode.com/posts';
        // Http.open("GET", url);
        // Http.send();

        // Http.onreadystatechange = (e) => {
        //    console.log(Http.responseText)
        //}
    }
    function showToken() {
        var x = document.getElementById("tokenCode");
        if (x.type === "password") {
          x.type = "text";
        } else {
          x.type = "password";
        }
    }
    
}(this, this.document));