using OnlineBanking.Data;
using OnlineBanking.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineBanking.Controllers
{
    public class CustomerAccountStatementController : Controller
    {
        // GET: CustomerAccountStatement

        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                c.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                var ch = new CustomerHelper();
                var model = new List<Accounts>();
                model = ch.FetchCustomerAccount(c);
                return View("ViewStatements", model);
            }
        }

        public ActionResult TransactionHistory(string selectedaccount, string selected, string from, string to)
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                var ch = new CustomerHelper();
                var f = new FetchTransactionsModel();
                f.accountno = selectedaccount;
                ViewData["AccNo"] = selectedaccount;
                f.fromdate = from;
                f.todate = to;
                c.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                var model = new List<Accounts>();
                model = ch.FetchCustomerAccount(c);
                foreach (var item in model)
                {
                    if (item.accountNum == int.Parse(selectedaccount))
                        ViewData["Bal"] = item.balance;
                }
                if (selected == "last10")
                {
                    ViewBag.Transactions = ch.FetchTransactions(f, false);
                    return View("ViewTransactions", model);
                }
                else
                {
                    ViewBag.Transactions = ch.FetchTransactions(f, true);
                    return View("ViewTransactions", model);
                }
            }
        }

    }
}