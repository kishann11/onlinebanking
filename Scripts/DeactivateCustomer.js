function Deactivate_Submit() {
   
    var regex_ID = /^[1-9](\d){7}$/;
    var cust_ID = document.getElementById("CID").value;
    if (regex_ID.exec(cust_ID)) {
        document.getElementById("DeactivateCustomerForm").submit();
        toastr.success('Details Fetched', 'Check!');
    }
    else {
        toastr.error('Enter valid ID', 'Error');
    }
}