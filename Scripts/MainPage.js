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

function Banker_Login()
{
    
    toastr.options = { timeOut: 1000 };

    banker_ID = document.getElementById("BankerUsername").value;
    
    
   
    var password = document.getElementById("BankerPassword").value;
    
    
    var regex_ID = /^[1-9](\d){7}$/;
    var regex_PW = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    if (regex_ID.test(banker_ID)) {
        
        if (regex_PW.test(password)) {
         
            
            document.getElementById('BankerLoginForm').submit();
            toastr.success('Successfully logged in', 'Welcome!');
         
               
            
        }
        else {
            toastr.error('Invalid Username or Password');
        }
    }
    else {
        
        toastr.error('Invalid Username or Password');
    }
}

function Customer_Login()
{
    toastr.options = { timeOut: 1000 };

    customer_ID = document.getElementById("CustomerUsername").value;
    
    
   
    var password = document.getElementById("CustomerPassword").value;
    
    
    var regex_ID = /^[1-9](\d){7}$/;
    var regex_PW = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    if (regex_ID.test(customer_ID)) {
        
        if (regex_PW.test(password)) {
         
            
            document.getElementById('CustomerLoginForm').submit();
            toastr.success('Successfully logged in', 'Welcome!');
         
               
            
        }
        else {
            toastr.error('Invalid Username or Password');
        }
    }
    else {
        
        toastr.error('Invalid Username or Password');
    }
}



