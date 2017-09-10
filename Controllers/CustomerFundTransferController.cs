using OnlineBanking.Data;
using OnlineBanking.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace OnlineBanking.Controllers
{
    public class CustomerFundTransferController : Controller
    {
        // GET: CustomerFundTransfer
        public ActionResult Index()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("FundTransfer");
            }
        }
        public ActionResult AddBeneficiary()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                return View("AddBeneficiary");
            }
        }

        public ActionResult AddBeneficiaryFinal(string benefname, int benefaccno)
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new Beneficiary();
                c.custId = HttpContext.Session["LoggedInCustomerId"].ToString();
                c.beneficiaryName = benefname;
                c.beneficiaryAccNo = benefaccno;
                var ch = new CustomerHelper();
                TempData["AddBeneficiaryMessage"] = ch.AddBeneficiary(c);
                return Redirect("/CustomerFundTransfer/Index");
            }
        }

        public ActionResult RemoveBeneficiary()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var cid = new Beneficiary();
                cid.custId = HttpContext.Session["LoggedInCustomerId"].ToString();
                var h = new CustomerHelper();
                var model1 = new List<Beneficiary>();
                model1 = h.fetchBeneficiaryAccount(cid);
                return View("RemoveBeneficiary", model1);
            }
        }

        public ActionResult RemoveBeneficiaryFinal(string selectedaccount)
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c1 = new Beneficiary();
                c1.custId = HttpContext.Session["LoggedInCustomerId"].ToString();
                c1.beneficiaryAccNo = int.Parse(selectedaccount);
                var ch = new CustomerHelper();
                ch.removeBeneficiary(c1);
                return Redirect("/CustomerFundTransfer/RemoveBeneficiary");
            }
        }

        public ActionResult TransferFunds()
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                var c = new CustomerDetails();
                c.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                var h = new CustomerHelper();
                var model1 = new List<Accounts>();
                model1 = h.FetchCustomerAccount(c);
                var b = new Beneficiary();
                b.custId = HttpContext.Session["LoggedInCustomerId"].ToString();
                ViewBag.Beneficiaries = h.fetchBeneficiaryAccount(b);
                return View("TransferFunds", model1);
                // return View();
            }
        }

        public ActionResult SendMoney(string selectedAccount, string selectedBeneficiary, float amount)
        {
            if (Session["LoggedInCustomerId"] == null)
            {
                return Redirect("/HomePage/Index");
            }
            else
            {
                if (Session["LoggedInCustomerId"] == null)
                {
                    return Redirect("/HomePage/Index");
                }
                else
                {
                    var t = new Transactions();
                    t.amount = amount;
                    t.recieverAccNo = int.Parse(selectedBeneficiary);
                    t.senderAccNo = int.Parse(selectedAccount.Substring(0, 8));
                    var ch = new CustomerHelper();
                    ViewData["TransferFunds"] = ch.SendMoney(t);
                    var c = new CustomerDetails();
                    c.cid = HttpContext.Session["LoggedInCustomerId"].ToString();
                    var b = new Beneficiary();
                    b.custId = HttpContext.Session["LoggedInCustomerId"].ToString();
                    ViewBag.Beneficiaries = ch.fetchBeneficiaryAccount(b);
                    return Redirect("/CustomerFundTransfer/TransferFunds");
                }
            }
        }


    }
}