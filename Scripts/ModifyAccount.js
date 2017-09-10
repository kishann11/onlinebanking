function Modify_Submit()
{
   
    toastr.options = { timeOut: 1000 };
    var regex_ID = /^[1-9](\d){7}$/;
    var cust_ID = document.getElementById("CID").value;
    if (regex_ID.exec(cust_ID)) {
        document.getElementById("ModifyFetch").submit();
        toastr.success('Details Fetched', 'Check!');
        var z = document.getElementById("details");
        
        z.style.display = 'block';
        var x = document.getElementById("customer");
        x.style.display = 'none';

    }
    else {
        toastr.error('Enter valid ID', 'Error');
    }
}

function Register_Submit() {
    toastr.options = { timeOut: 1000 };
   // var ssn_var = document.getElementById("SSN").value;

    var fname_var = document.getElementById("Fname").value;
    var lname_var = document.getElementById("Lname").value;
    var add_var = document.getElementById("Address").value;
    var phn_var = document.getElementById("phnumber").value;
    var email_var = document.getElementById("Email").value;
   // var bal_var = document.getElementById("Balance").value;
    var regex_str = /^([A-Z]||[a-z])+$/;
    var regex_phone = /^([0-9]){10}$/;
    var regex_email = /^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/;
  //  var regex_bal = /(^[5-9][\d]{3}[\d]*$)||(^[1-9][\d]{4}[\d]*$)/;


    /*if ((ssn_var.toString().length) != 8) {
        toastr.error('Enter SSN of 8 characters', 'Invalid SSN');
    }*/

   if (!regex_str.exec(fname_var)) {
        toastr.error('Enter valid username', 'Invalid first name');

    }
    else if (!(regex_str.exec(lname_var))) {
        toastr.error('Enter valid username', 'Invalid last name');

    }
  /*  else if (!regex_bal.exec(bal_var)) {
        toastr.error('Enter balance above 5000', 'Invalid Balance');
    }*/

    else if (!regex_phone.exec(phn_var)) {
        toastr.error('Enter valid 10 digit phone number', 'Invalid phone');
    }
    else if (!regex_email.exec(email_var)) {
        toastr.error('Enter valid email id', 'Invalid email');
    }
    else {
        document.getElementById("UpdateCustomer").submit();
    }

}