using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineBanking.Data;
using OnlineBanking.Helpers;

namespace OnlineBanking.Controllers
{
    public class ForgotCustomerIdController : Controller
    {
        // GET: ForgotCustomerId
        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                return View("ForgotCustomerId");
            }
        }

        public ActionResult SendCustomerId(string ssn)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                var ch = new CustomerHelper();
                var c = new CustomerDetails();
                c.cid = ssn;
                if (ch.ForgotCustomerId(c))
                {
                    TempData["ForgotCustomerId"] = "CustomerId has been sent to your registered email";
                    return Redirect("/ForgotCustomerId/Index");
                }
                else
                {
                    TempData["ForgotCustomerId"] = "SSN does not exist";
                    return Redirect("/ForgotCustomerId/Index");
                }
            }
        }

    }
}