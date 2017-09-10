function Register_Submit()
{
    toastr.options = { timeOut: 1000 };
    var ssn_var = document.getElementById("SSN").value;
    
    var fname_var = document.getElementById("Fname").value;
    var lname_var = document.getElementById("Lname").value;
    var add_var = document.getElementById("Address").value;
    var phn_var = document.getElementById("phnumber").value;
    var email_var = document.getElementById("Email").value;
    //var bal_var = document.getElementById("Balance").value;
    var date = document.getElementById("date").value;
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth() + 1; 

    var yyyy = today.getFullYear();
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    var today = yyyy + '-' + mm + '-' + dd;
   // alert(date);
   // alert(today);
    var regex_str = /^([A-Z]||[a-z])+$/;
    var regex_phone = /^([0-9]){10}$/;
    var regex_email = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
    //var regex_bal = /(^[5-9][\d]{3}[\d]*$)||(^[1-9][\d]{4}[\d]*$)/;
    var text = add_var;
    
    
    
    if ((ssn_var.toString().length)!=9)
    {
        toastr.error('Enter SSN of 9 characters','Invalid SSN');
    }
    else if(!(add_var.length)||(text.trim()==0))
    {
        toastr.error('Do not leave address blank', 'Invalid address');
    }
    else if(!regex_str.exec(fname_var)) 
    {
        toastr.error('Enter valid firstname', 'Invalid first name');

    }
    else if(!(regex_str.exec(lname_var)))
    {
        toastr.error('Enter valid lastname', 'Invalid last name');

    }
    else if(date > today)
    {
        toastr.error('Enter valid date', 'Invalid date');

    }
    //else if (!regex_bal.exec(bal_var)) {
    //    toastr.error('Enter balance above 5000', 'Invalid Balance');
    //}
    else if(!regex_phone.exec(phn_var))
    {
        toastr.error('Enter valid 10 digit phone number', 'Invalid phone');
    }
    else if(!regex_email.exec(email_var))
    {
        toastr.error('Enter valid email id', 'Invalid email');
    }
    else {
       
        document.getElementById("RegisterForm").submit();
        toastr.success("Congrats!", "Registered!");
            
        
    }
    

}