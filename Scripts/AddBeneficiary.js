function Validate_Name() {
    var name = document.getElementById("name").value;
    var accno = document.getElementById("accnumber").value;
    toastr.options = {timeOut:1000};
    
    if(!(name)){
        toastr.error('Enter a valid name', 'Error');
    }
    else if(accno.toString().length!=8){
        toastr.error('Enter a valid account number','Error')
    }
    else {
        var conf = confirm('Are you sure you want to add beneficiary?');
        if (conf) {
            toastr.success('Beneficiary Added!', 'Done!');
            document.getElementById("ben_form").submit();
        }
    }
}    

//function validate_name() {
    
//        var name = document.getElementById("name").value;
//        var lbl = document.getElementById("errormsg");
//        var regex_name = /^[a-z'´`]+\.?\s([a-z'´`]+\.?\s?)+$/;
//        if (!regex_name.exec(name)) {
//            lbl.style.display = "block"
//        }
//        else {
//            lbl.style.display = "none";
//        }
//    }
//    function validate_accno() {
//        var accno = document.getElementById("accnumber").value;
//        if(accno.toString().length!=8){
//            alert("Enter a valid account number!");
//        }
//    }
