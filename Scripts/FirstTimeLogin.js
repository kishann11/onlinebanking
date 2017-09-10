function First_Submit()
{
    var ans1 = document.getElementById("answer1").value;
    var ans2 = document.getElementById("answer2").value;
    var que = document.getElementById("customques").value;
    var pass1 = document.getElementById("pwd1").value;
    var pass2 = document.getElementById("pwd2").value;
    var regex_pass = /^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{8,}$/;
    var ans1_text = ans1.trim();
    var ans1_length = ans1.length;
    var ans2_text = ans2.trim();
    var ans2_length = ans2.length;
    var que_text = que.trim();
    var que_length = que_text.length;
    if(ans1!=null && ans2!=null && que!=null && pass1!=null && pass2!=null && ans1_length!=0 && ans2_length!=0 && que_length!=0)
    {
        if(regex_pass.exec(pass1) && regex_pass.exec(pass2))
        {
            if(pass1==pass2)
            {
                document.getElementById("FirstTimeSubmitForm").submit();
            }
            else
            {
                toastr.error('Passwords do not match','Error');
            }
        }
        else
        {
            toastr.error('Passwords must fulfill all the requirements','Error');
        }
    }
    else
    {
        toastr.error('Please enter all the fields!','Error');
    }
    
}