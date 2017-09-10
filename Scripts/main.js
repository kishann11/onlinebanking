function Banker_click() {
    var x = document.getElementById("BankerSignIn");
    x.style.display = 'block';
    var y = document.getElementById("CustomerSignIn");
    y.style.display = 'none';
    var z = document.getElementById("BankLink");
    z.style.backgroundColor = "#4CAF50";
    var a = document.getElementById("CustLink");
    a.style.backgroundColor = "black";
}

function Customer_click() {
    var x = document.getElementById("BankerSignIn");
    x.style.display = 'none';
    var y = document.getElementById("CustomerSignIn");
    y.style.display = 'block';
    var z = document.getElementById("BankLink");
    z.style.backgroundColor = "black";
    var a = document.getElementById("CustLink");
    a.style.backgroundColor = "#4CAF50";
}