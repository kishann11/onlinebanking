function Change_Password() {
    var pass1 = document.getElementById("pwd1").value;
    var pass2 = document.getElementById("pwd2").value;
    var regex_pass = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    if(pass1!=null && pass2!=null)
    {
        if(pass1==pass2)
        {
            if (regex_pass.exec(pass1) && regex_pass.exec(pass2))
            {
                document.getElementById("ResetPasswordForm").submit();
            }
            else
            {
                toastr.error('Password must fulfill all the requirements!','error');
            }
        }
        else
        {
            toastr.error('Passwords do not match!','Error');
        }
    }
    else
    {
        toastr.error('Please enter both the passwords!','Error');
    }
    
}