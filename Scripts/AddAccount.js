function Add_Submit()
{
    toastr.options = { timeOut: 1000 };
    
    var regex_ID = /^[1-9](\d){7}$/;
    var cust_ID = document.getElementById("CID").value;
    var x = document.getElementById("amount").value;
    if (!regex_ID.exec(cust_ID)) {
        toastr.error('Enter valid ID', 'Error');
    }
    else if(x<5000){
        toastr.error('Amount cannot be less than 5000', 'Error');
    }  
  
     else{
        
            toastr.success('Account added', 'Done!');
            document.getElementById("AddAccountForm").submit();
    }
}


