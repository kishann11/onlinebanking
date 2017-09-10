using System.Web.Mvc;
using OnlineBanking.Data;
using OnlineBanking.Helpers;

namespace OnlineBanking.Controllers
{
    public class BankerController : Controller
    {
        // GET: Banker
        public ActionResult Index()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("BankerHomepage");
            }
        }

        public ActionResult ModifyAccount()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                return View("ModifyAccount", c);
            }
        }

        public ActionResult ModifyFetch(string cid)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {

                var b = new BankerHelper();
                var c = new CustomerDetails();
                c.cid = cid;
                c = b.FetchDetails(c);
                return View("ModifyAccount", c);
            }
        }

        public ActionResult UpdateCustomer(string firstname, string lastname, string dob, string address, long phno, string email)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                c.firstName = firstname;
                c.lastName = lastname;
                c.dateOfBirth = dob;
                c.address = address;
                c.phone = phno;
                c.email = email;
                c.cid = HttpContext.Session["customerid"].ToString();
                var b = new BankerHelper();
                b.UpdateCustomer(c);
                TempData["ModifyAccount"] = "Modified Successfully";
                return Redirect("/Banker/Index");
            }
        }

        public ActionResult RegisterCustomer()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("RegisterCustomer");
            }
        }

        public ActionResult Register(string ssn, string firstname, string lastname, string dob, string address, long phno, string email)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                c.firstName = firstname;
                c.lastName = lastname;
                c.dateOfBirth = dob;
                c.address = address;
                c.phone = phno;
                c.email = email;
                c.cid = ssn;
                var b = new BankerHelper();
                if (b.CheckCreditScore(c))
                {
                    b.RegisterCustomer(c);
                    ViewData["RegisterMessage"] = "Successfully Registered";
                    return View("RegisterCustomer");
                }
                else
                {
                    ViewData["RegisterMessage"] = "Not a Eligible Customer";
                    return View("RegisterCustomer");
                }

            }
        }


        public ActionResult AddAccount()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("AddAccount");
            }
        }

        public ActionResult AddAccountData(string cid, double amount, string accountType)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var b = new BankerHelper();
                var c = new CustomerDetails();
                var d = new CustomerDetails();

                c.cid = cid;
                d.cid = b.FetchSSN(c);
                if (b.CheckCreditScore(d))
                {
                    var a = new Accounts();
                    c.cid = cid;
                    a.accountType = accountType;
                    a.balance = amount;
                    b = new BankerHelper();
                    TempData["AccountMessage"] = b.AddAccount(c, a);
                    return Redirect("/Banker/AddAccount");
                }
                else
                {
                    TempData["AccountMessage"] = "Customer is not eligible";
                    return Redirect("/Banker/AddAccount");
                }
            }
        }

        public ActionResult CloseAccount()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("CloseAccount");
            }
        }

        public ActionResult CloseAccountFunc(int accno)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var a = new Accounts();
                a.accountNum = accno;
                var b = new BankerHelper();
                TempData["CloseAccountMessage"] = b.CloseAccount(a);
                return Redirect("/Banker/CloseAccount");
            }
        }

        public ActionResult DeactivateCustomer()
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("DeactivateCustomer");
            }
        }

        public ActionResult DeactivateCustomerFunc(string cid)
        {
            if (Session["bankerid"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                c.cid = cid;
                var b = new BankerHelper();
                TempData["DeactivateCustomerMessage"] = b.DeactivateCustomer(c);
                return Redirect("/Banker/DeactivateCustomer");
            }
        }


    }
}