function Close_Submit()
{
    toastr.options = { timeOut: 1000 };
    var regex_ID = /^[1-9](\d){7}$/;
    var cust_ID = document.getElementById("AccNo").value;
    if (regex_ID.exec(cust_ID)) {
        document.getElementById("CloseAccountForm").submit();
        toastr.success('Success', 'Check!');
    }
    else {
        toastr.error('Enter valid ID', 'Error');
    }
}