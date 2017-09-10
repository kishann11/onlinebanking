using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OnlineBanking.Data
{
    public class CustomerDetails
    {
        public string cid { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string address { get; set; }
        public string email { get; set; }
        public long phone { get; set; }
        public string dateOfBirth { get; set; }
    }

    public class Login
    {
        public string id;
        public string password;
    }
    public class Accounts
    {
        public string accountType { get; set; }
        public int accountNum { get; set; }
        public double balance { get; set; }
        public string customerid { get; set; }
    }

    public class Transactions
    {
        public int transactionId { get; set; }
        public string date { get; set; }
        public string time { get; set; }
        public float amount { get; set; }
        public int senderAccNo { get; set; }
        public int recieverAccNo { get; set; }


    }


    public class SecurityQuestions
    {
        public int qid { get; set; }
        public string qname { get; set; }
    }


    public class ChangePasswordModel
    {
        public string oldpass { get; set; }
        public string newpass { get; set; }
        public string cid { get; set; }

    }

    public class FetchTransactionsModel
    {
        public string accountno { get; set; }
        public string fromdate { get; set; }
        public string todate { get; set; }

    }

    public class UpdateSecurityQstns
    {
        public string qid1 { get; set; }
        public string answer1 { get; set; }
        public string question2 { get; set; }
        public string answer2 { get; set; }
        
    }

    public class MailModel
    {
        public string toAddress { get; set; }
        public string subject { get; set; }
        public string body { get; set; }
    }

    public class Beneficiary
    {
        public string beneficiaryName { get; set; }
        public int beneficiaryAccNo { get; set; }
        public string custId { get; set; }
    }

}
