(function (window, document) {

    document.getElementById("showToken").onclick = showToken;
    
    function showToken() {
        var tc = document.getElementById("tokenCode");
        var cu = document.getElementById("codeusage");
        if (tc.type === "password") {
          tc.type = "text";
          cu.style.display = "none";
        } else {
          tc.type = "password";
          cu.style.display = "block";
        }
    }
    
}(this, this.document));