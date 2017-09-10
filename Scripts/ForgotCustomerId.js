function Forgot_Customer() {

    toastr.options = { timeOut: 1000 };
    var regex_ID = /^[1-9](\d){8}$/;
    var cust_ID = document.getElementById("Acc").value;
    var text2 = cust_ID.trim();
    var text = text2.length;
    if (regex_ID.exec(cust_ID) && (text != 0)) {
        
        document.getElementById("ForgotCustomerIdForm").submit();
        toastr.success('Success', 'Mail has been sent');
    }
    else
    {
        toastr.error('Enter valid ID', 'Error');
    }
   
}