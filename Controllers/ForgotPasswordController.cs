using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineBanking.Data;
using OnlineBanking.Helpers;
using System.Web.Mvc;

namespace OnlineBanking.Controllers
{
    public class ForgotPasswordController : Controller
    {
        // GET: ForgotPassword
        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                return View("ForgotPasswordPre");
            }
        }

        public ActionResult FetchQuestions(string cid)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                HttpContext.Session["ForgotPassword"] = cid;
                var c = new ChangePasswordModel();
                c.cid = cid;
                var s = new UpdateSecurityQstns();
                var ch = new CustomerHelper();
                s = ch.FetchSecurityQuestions(c);
                if (s.qid1 == null)
                {
                    ViewData["ForgotPasswordPre"] = "Invalid CUstomerId";
                    return View("ForgotPasswordPre");
                }
                else
                    return View("ForgotPassword", s);
            }
        }


        public ActionResult AnswerQuestions(string ans1, string ans2)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                var c = new ChangePasswordModel();
                c.cid = HttpContext.Session["ForgotPassword"].ToString();
                var s = new UpdateSecurityQstns();
                s.answer1 = ans1;
                s.answer2 = ans2;
                var ch = new CustomerHelper();
                if (ch.AnswerQuestions(s, c))
                {
                    return View("ResetPassword");
                }
                else
                {
                    TempData["ForgotPasswordPre"] = "Wrong Answers";
                    return Redirect("/ForgotPassword/Index");
                }
            }
        }


        public ActionResult ResetPassword(string pass1)
        {
            if (Session["LoggedInCustomerId"] != null || Session["bankerid"] != null)
            {
                return Redirect("/HomePage/Logout");
            }
            else
            {
                var c = new ChangePasswordModel();
                c.cid = HttpContext.Session["ForgotPassword"].ToString();
                c.newpass = pass1;
                var ch = new CustomerHelper();
                ch.ChangePasswordForgot(c);
                TempData["CustomerMessage"] = "Password Reset Successfully";
                return Redirect("/HomePage/Index");
            }
        }

    }
}