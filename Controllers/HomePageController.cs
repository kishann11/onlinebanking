using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineBanking.Helpers;
using OnlineBanking.Data;
using System.Web.Security;

namespace OnlineBanking.Controllers
{
    public class HomePageController : Controller
    {
        // GET: HomePage
        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] != null)
            {
                return Redirect("/Customer/Index");
            }
            else if(Session["bankerid"] != null)
            {
                return Redirect("/Banker/Index");
            }
            else
            {
                return View("MainPage");
            }
        }

        public ActionResult Instruction()
        {
            return View("InstructionPage");
        }

        public ActionResult ForgotPassword()
        {
            if (Session["LoggedInCustomerId"] != null)
            {
                return Redirect("/Customer/Index");
            }
            else
            {
                return Redirect("/ForgotPassword/Index");
            }
        }

        public ActionResult ForgotCustomerId()
        {
            if (Session["LoggedInCustomerId"] != null )
            {
                return Redirect("/Customer/Index");
            }
            else
            {
                return Redirect("/ForgotCustomerId/Index");
            }
        }

        public ActionResult BankerLogin(string bankerUname, string bankerPassword)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                var b = new BankerHelper();
                var obj = new Login();
                obj.id = bankerUname;
                obj.password = bankerPassword;
                if (b.BankerLogin(obj))
                {
                    b.UpdateLastLogin(obj);
                    return Redirect("/Banker/Index");
                }

                TempData["BankerMessage"] = "Invalid Username or Password";
                return Redirect("/Homepage/Index");
            }
        }

        public ActionResult CustomerLogin(string cid, string cpass)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                var c = new CustomerHelper();
                var obj = new Login();
                obj.id = cid;
                obj.password = cpass;
                int result = c.CustomerLogin(obj);
                if (result == 1)
                {
                    return Redirect("/FirstTimeLogin/Index");
                }
                else if (result == 2)
                {
                    c.UpdateLastLogin(obj);
                    return Redirect("/Customer/Index");
                }
                else
                {
                    TempData["CustomerMessage"] = "Invalid Username or Password";
                    return Redirect("/Homepage/Index");
                }

            }
        }

        public ActionResult LogOut()
        {
            Session.Clear();
            Session.RemoveAll();
            Session.Abandon();
            FormsAuthentication.SignOut();
            return Redirect("/HomePage/Index");
        }

        public ActionResult ErrorPage()
        {
            return View("ErrorPage");
        }

    }
}