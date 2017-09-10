using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using OnlineBanking.Data;
using System.Web.Mvc;
using OnlineBanking.Helpers;

namespace OnlineBanking.Controllers
{
    public class FirstTimeLoginController : Controller
    {
        // GET: FirstTimeLogin
        public ActionResult Index()
        {
            if (Session["FirstTimeLogin"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var ch = new CustomerHelper();
                var model = new List<SecurityQuestions>();
                model = ch.FetchSecurityQuestions();
                return View("FirstTimeLogin", model);
            }
        }

        public ActionResult UpdateSecurity(string qid1, string answer1, string question2, string answer2, string pass1)
        {
            if (Session["FirstTimeLogin"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var ch = new CustomerHelper();
                var s = new UpdateSecurityQstns();
                var p = new ChangePasswordModel();
                s.qid1 = qid1;
                s.answer1 = answer1;
                s.question2 = question2;
                s.answer2 = answer2;
                p.cid = HttpContext.Session["FirstTimeLogin"].ToString();
                p.newpass = pass1;
                ch.UpdateSecurityQuestions(s, p);
                ch.ChangePasswordForgot(p);
                TempData["CustomerMessage"] = "Succesfully updated details";
                return Redirect("/HomePage/Index");
            }
        }

    }
}