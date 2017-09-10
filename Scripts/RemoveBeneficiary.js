function Remove_Submit() {
    var x = document.getElementById("name").value;
    if (!x) {
        toastr.options = { timeOut: 1000 };
        toastr.error('No Beneficiary!','Error');
    }
    else {
        var conf = confirm("Are you sure you want to remove beneficiary?");
        if (conf) {
            toastr.options = { timeOut: 1000 };
            toastr.success('Beneficiary Removed!', 'Success');
            document.getElementById("rem_form").submit();
            
        }

    }
}