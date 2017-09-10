function Validate_Amount() {
    var ben_var = document.getElementById("beneficiary").value;
    var send_var = document.getElementById("account").value;
    var act_var = send_var.substring(0, 8);
    var len = send_var.length;
    var bal_var = parseInt(send_var.substring(8, (len)));
    var amnt_var = parseInt(document.getElementById("amount").value);
    if (!ben_var) {
        toastr.options = { timeOut: 1000 };
        toastr.info("Can't transfer without beneficiary", "Error");
    }

    else if (!amnt_var) {
        toastr.options = { timeOut: 1000 };
        toastr.info("Please enter a valid amount", "Error");
    }


    else if (act_var == ben_var) {
        toastr.options = { timeOut: 1000 };
        toastr.info("Cannot transfer money to same account", "Info");
    }
    else if (bal_var < amnt_var) {
        toastr.options = { timeOut: 1000 };
        toastr.error("Insufficient Balance", "Error");

    }
    else if (amnt_var < 1) {
        toastr.options = { timeOut: 1500 };
        toastr.error("Minimum transfer amount is $1", "Error");
    }
    else if ((bal_var - amnt_var) < 5000) {

        var conf = confirm("Balance goes below 5000 after transfer. You will be fined at end of month. Please confirm");
        if (conf) {
            document.getElementById("TransferFundsForm").submit();
        }
        else {
            toastr.options = { timeOut: 1500 };
            toastr.info("Transaction was cancelled", "Verify");

        }
    }
    else {
        document.getElementById("TransferFundsForm").submit();
    }


    //var amt = document.getElementById("amount").value;
    //toastr.options = { timeOut: 1000 };
    //if (amt>=1) {
    //    var conf = confirm('Are you sure you want to transfer funds?');
    //    if (conf) {
    //        toastr.success('Successfully Transferred!', 'Done!');
    //        document.getElementById("TransferFundsForm").submit();
    //    }

    //}
    //else {
    //    toastr.error('Please enter a valid amount!', 'Error');
    //}
}