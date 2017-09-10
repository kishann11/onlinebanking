function Forgot_Password()
{
    var cust_ID = document.getElementById("cid").value;
    var regex_ID = /^[1-9](\d){7}$/;
   
    if (regex_ID.exec(cust_ID)) {
        
        toastr.success('Success', 'Check!');
        document.getElementById("FetchQuestions").submit();
    }
    else {
        toastr.error('Enter valid ID', 'Error');
    }
    
    
}