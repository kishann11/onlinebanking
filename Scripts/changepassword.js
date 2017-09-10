function Validate_Password() {
    var oldpass = document.getElementById("oldpass").value;
    var newpass = document.getElementById("newpass").value;
    var confpass = document.getElementById("confirmpass").value;
    var regex_pass = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    if(oldpass==newpass){
        toastr.error('Old password and new password cannot be same!','Error');
    }
    else if(newpass!=confpass){
        toastr.error('Passwords do not match!','Error');
    }
    else if(!(regex_pass.exec(newpass))){
        toastr.error('Password should fulfil all the conditions!','Error');
    }
    else {
        alert("Are you sure you want to change the password?");
        document.getElementById("chng_form").submit();
        
    }

}