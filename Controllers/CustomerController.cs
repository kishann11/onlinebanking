using OnlineBanking.Data;
using OnlineBanking.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineBanking.Controllers
{
    public class CustomerController : Controller
    {
        // GET: Customer

        public ActionResult ViewStatement()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return Redirect("/CustomerAccountStatement");
            }
        }
        public ActionResult FundTransfer()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return Redirect("/CustomerFundTransfer/Index");
            }
        }

        public ActionResult ChangePassword()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("ChangePassword");
            }
        }

        public ActionResult ChangePasswordFinal(string oldpass, string newpass)
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new ChangePasswordModel();
                c.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                c.oldpass = oldpass;
                c.newpass = newpass;
                var ch = new CustomerHelper();
                TempData["ChangePasswordMessage"] = ch.ChangePassword(c);
                return Redirect("/Customer/ChangePassword");
            }
        }

        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("CustomerDashboard");
            }
        }



        public ActionResult CheckBalance()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var customerbal = new Accounts();
                customerbal.customerid = HttpContext.Session["LoggedInCustomerId"].ToString();
                var balinfo = new CustomerHelper();
                var customerBalInfoModel = new List<Accounts>();
                customerBalInfoModel = balinfo.fetchCustomerAccInfo(customerbal);

                return View("CheckBalance", customerBalInfoModel);

            }
        }

        public ActionResult ViewProfile()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var customerinfo = new CustomerDetails();
                customerinfo.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                var info = new CustomerHelper();
                var customerInfoModel = new List<CustomerDetails>();
                customerInfoModel = info.fetchCustomerInfo(customerinfo);

                return View("ViewProfile", customerInfoModel);
            }
        }
   

    }
}