window.onload = loader();

function loader() {
    var to_date = null;
    var from_date = null;
}

function ShowDate() {
    var x = document.getElementById("dates");
    x.style.display = "block";
    document.getElementById("switch_off").innerHTML = "";
    


    
}

function HideDate() {
    var x = document.getElementById("dates");
    x.style.display = "none";
    document.getElementById("switch_off").innerHTML = "";
    
}

function Fetch_Transactions()
{
  //  alert("Hit function");
    //  alert(x);
    
   
    {
        if (document.getElementById("radio1").checked) {
            var x = document.getElementById("radio1").value;
        }
        else if(document.getElementById("radio2").checked){
            var x = document.getElementById("radio2").value;
            //alert(x);
        }
        else
        {
           // alert("Wrong");
        }
    }

    {
        if (x == "last10")
        {
            document.getElementById("viewStatements").submit();
        }
        else if (x == "datefromto")
        {
            var to_date = document.getElementById("todate").value;
            var from_date = document.getElementById("fromdate").value;

            var today = new Date();
            var dd = today.getDate();
            var mm = today.getMonth() + 1;

            var yyyy = today.getFullYear();
            if (dd < 10) {
                dd = '0' + dd;
            }
            if (mm < 10) {
                mm = '0' + mm;
            }
            var today = yyyy + '-' + mm + '-' + dd;

            if ((!to_date) || (!from_date))
            {
                toastr.options = { timeOut: 1500 };
                toastr.error("Please enter both date values", "Error");
            }
            else if (from_date > to_date)
            {
                toastr.options = { timeOut: 1500 };
                toastr.info("From date should be before To date", "Info");
            }
            else if (from_date > today)
            {
                toastr.options = { timeOut: 1500 };
                toastr.info("From date should be before current date", "Info");
            }
            else
            {
                document.getElementById("viewStatements").submit();
            }

            


        }
    }

   

    
    
}