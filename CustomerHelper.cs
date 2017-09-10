using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using OnlineBanking.Data;
using System.Data;

namespace OnlineBanking.Helpers
{
    public class CustomerHelper
    {
        private String connectionString = "Data Source=tcp:192.168.14.106,40000;Initial Catalog=OnlineBanking;Integrated Security=True";
        private SqlConnection conn;
        private SqlDataReader rdr;
        private SqlCommand cmd;
        private String sql;

        internal List<CustomerDetails> fetchCustomerInfo(CustomerDetails c)
        {
            String sql = "SELECT firstname,lastname,CONVERT(varchar(12),dob,120) as dob,homeaddress,emailid,phoneno FROM customerinfo where customerid=" + c.cid;
            var model = new List<CustomerDetails>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var cust = new CustomerDetails();
                    cust.firstName = rdr["firstname"].ToString();
                    cust.lastName = rdr["lastname"].ToString();
                    cust.dateOfBirth = rdr["dob"].ToString();
                    cust.address = rdr["homeaddress"].ToString();
                    cust.email = rdr["emailid"].ToString();
                    cust.phone = long.Parse(rdr["phoneno"].ToString());

                    model.Add(cust);
                }
                conn.Close();
                return model;
            }

        }


        internal int CustomerLogin(Login obj)
        {
            sql = "SELECT customerid,lastlogin FROM customerinfo where customerid=" + obj.id + " and pass=HASHBYTES('SHA2_512','" + obj.password + "')";

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        if (String.IsNullOrEmpty(rdr["lastlogin"].ToString()))
                        {
                            HttpContext.Current.Session["FirstTimeLogin"] = rdr["customerid"];
                            conn.Close();
                            return 1;
                        }
                        else
                        {
                            HttpContext.Current.Session["lastlogin"] = rdr["lastlogin"];
                            HttpContext.Current.Session["customerid"] = rdr["customerid"];
                            conn.Close();
                            return 2;
                        }
                    }
                    conn.Close();
                    return 3;
                }
            }

        }

        internal void UpdateLastLogin(Login obj)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "update customerinfo set lastlogin=CONVERT(smalldatetime,GETDATE()) where customerid=" + obj.id;
                    HttpContext.Current.Session["LoggedInCustomerId"]= obj.id;
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }


        internal List<Accounts> FetchCustomerAccount(CustomerDetails c)
        {
             sql = "SELECT accountno,accounttype,balance from  accountinfo where customerid="+c.cid;
            var accounts = new List<Accounts>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var a = new Accounts();
                    a.accountNum = int.Parse(rdr["accountno"].ToString());
                    a.accountType = rdr["accounttype"].ToString();
                    a.balance = float.Parse(rdr["balance"].ToString());
                    accounts.Add(a);
                }
                conn.Close();
                return accounts;
            }

        }

        internal List<Transactions> FetchTransactions(FetchTransactionsModel f,bool x)
        {
            if(!x)
             sql = "select top(10) transactionid,senderaccno,receiveraccno,amount,convert(varchar(12),date,120)as date,convert(varchar(12),time,108) as time from transactions where senderaccno=" + f.accountno+" or receiveraccno="+f.accountno+ " order by date desc,time desc";
            else
              sql = "select transactionid,senderaccno,receiveraccno,amount,convert(varchar(12),date,120)as date,convert(varchar(12),time,108) as time from transactions where (senderaccno=" + f.accountno + " or receiveraccno=" + f.accountno + ") and (convert(varchar(12),date,120)>='" + f.fromdate + "' or convert(varchar(12),date,120)<='" + f.todate + "') order by date desc,time desc";
            var customertransaction = new List<Transactions>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var c = new Transactions();
                    c.transactionId = int.Parse(rdr["transactionId"].ToString());
                    c.senderAccNo = int.Parse(rdr["senderAccNo"].ToString());
                    c.recieverAccNo = int.Parse(rdr["receiverAccNo"].ToString());
                    c.amount = float.Parse(rdr["amount"].ToString());
                    c.date = rdr["date"].ToString();
                    c.time = rdr["time"].ToString();

                    customertransaction.Add(c);
                }
                conn.Close();
                return customertransaction;
            }

        }

        internal string ChangePassword(ChangePasswordModel c)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "update customerinfo set pass=HASHBYTES('SHA2_512','" + c.newpass + "') where customerid=" + c.cid+ "and pass=HASHBYTES('SHA2_512','" + c.oldpass + "')";
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    if(recordsAffected==0)
                    {
                        conn.Close();
                        return "Invalid Password Entered";
                    }
                    else
                    {
                        conn.Close();
                        return "Password Changed Successfully";
                    }
                }
            }
        }


        internal List<SecurityQuestions> FetchSecurityQuestions()
        {
            sql = "SELECT qid,qname from securityquestion";
            var s = new List<SecurityQuestions>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var a = new SecurityQuestions();
                    a.qid = int.Parse(rdr["qid"].ToString());
                    a.qname = rdr["qname"].ToString();
                    s.Add(a);
                }
                conn.Close();
                return s;
            }
        }


        internal void UpdateSecurityQuestions(UpdateSecurityQstns s,ChangePasswordModel p)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "INSERT into security(customerid,question1,answer1,question2,answer2) VALUES (@cid, @qid,@ans1,@question2,@ans2)";
                    cmd.Parameters.AddWithValue("@cid",p.cid );
                    cmd.Parameters.AddWithValue("@qid",s.qid1);
                    cmd.Parameters.AddWithValue("@ans1",s.answer1);
                    cmd.Parameters.AddWithValue("@question2",s.question2);
                    cmd.Parameters.AddWithValue("@ans2",s.answer2);
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }


        internal UpdateSecurityQstns FetchSecurityQuestions(ChangePasswordModel c)
        {
            sql = "SELECT qname,question2 from security s,securityquestion sq where sq.qid=s.question1 and customerid=" + c.cid;
            var s = new UpdateSecurityQstns();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    s.qid1 = rdr["qname"].ToString();
                    s.question2 = rdr["question2"].ToString();
                }
                conn.Close();
                return s;
            }
        }


        internal bool AnswerQuestions(UpdateSecurityQstns s,ChangePasswordModel c)
        {
            sql = "SELECT customerid from security where customerid=" + c.cid + "and answer1='" + s.answer1 + "'and answer2='" + s.answer2+"'";

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        conn.Close();
                        return true;
                    }
                    conn.Close();
                    return false;
                }
            }
        }


        internal void ChangePasswordForgot(ChangePasswordModel p)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "update customerinfo set pass=HASHBYTES('SHA2_512','" + p.newpass + "'),lastlogin=convert(date,GETDATE()) where customerid=" + p.cid;
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                   
                }
            }
           
        }


        internal bool ForgotCustomerId(CustomerDetails c)
        {
            sql = "SELECT customerid,emailid from customerinfo where ssn=" + c.cid;

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        var m = new MailModel();
                        m.toAddress = rdr["emailid"].ToString();
                        var cid = rdr["customerId"].ToString();
                        m.subject = "Forgot CustomerId";
                        m.body = "Your CustomerId is:" + cid;
                        var e = new Mail();
                        e.SendEmail(m);
                        conn.Close();
                        return true;
                    }
                    conn.Close();
                    return false;
                }
            }
        }



        internal String AddBeneficiary(Beneficiary c)
        {
            Int32 UserExist = 0;
            Int32 UserExist1 = 0;
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;

                    cmd.CommandText = "SELECT count(*) FROM accountinfo WHERE accountno =" + c.beneficiaryAccNo;
                    conn.Open();
                    UserExist = (Int32)cmd.ExecuteScalar();
                    conn.Close();
                    cmd.CommandText = "SELECT count(*) FROM beneficiary WHERE beneficiaryaccno =" + c.beneficiaryAccNo + "and customerid=" + c.custId;
                    conn.Open();
                    UserExist1 = (Int32)cmd.ExecuteScalar();
                    conn.Close();
                    if (UserExist == 1 && UserExist1 == 0) //anything different from 1 should be wrong
                    {
                        //Username Exist

                        cmd.CommandText = "INSERT into beneficiary(customerid,beneficiaryaccno,beneficiaryname) VALUES (@customerid,@benefaccno,@benefname)";
                        cmd.Parameters.AddWithValue("@customerid", c.custId);
                        cmd.Parameters.AddWithValue("@benefaccno", c.beneficiaryAccNo);
                        cmd.Parameters.AddWithValue("@benefname", c.beneficiaryName);

                        conn.Open();
                        int recordsAffected = cmd.ExecuteNonQuery();
                        conn.Close();
                        //if (recordsAffected == 0)
                        //{
                        //    conn.Close();
                        //    return "invalid credentials";
                        //}
                        return "added";
                    }
                    else
                    {
                        return "beneficiary not added";
                    }



                }
            }
        }
        internal List<Beneficiary> fetchBeneficiaryAccount(Beneficiary c)
        {
            String sql = "SELECT b.beneficiaryaccno,b.beneficiaryname from beneficiary b,accountinfo a where b.beneficiaryaccno=a.accountno and flag=1 and b.customerid=" + c.custId;
            var beneficiaryaccount = new List<Beneficiary>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var c1 = new Beneficiary();
                    c1.beneficiaryAccNo = int.Parse(rdr["beneficiaryaccno"].ToString());
                    c1.beneficiaryName = rdr["beneficiaryname"].ToString();
                    beneficiaryaccount.Add(c1);
                }
                conn.Close();
                return beneficiaryaccount;
            }

        }
        internal void removeBeneficiary(Beneficiary c)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "delete from beneficiary where customerid=" + c.custId + "and beneficiaryaccno=" + c.beneficiaryAccNo;

                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }
        internal List<Accounts> fetchCustomerAccInfo(Accounts c)
        {
            String sql = "SELECT accountno,balance,accounttype from accountinfo where customerid=" + c.customerid+"and flag=1";
            var model = new List<Accounts>();
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    var cust = new Accounts();
                    cust.accountNum = int.Parse(rdr["accountno"].ToString());
                    cust.accountType = rdr["accounttype"].ToString();
                    cust.balance = float.Parse(rdr["balance"].ToString());
                    model.Add(cust);
                }
                conn.Close();
                return model;
            }

        }

       
        internal string SendMoney(Transactions t)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "update accountinfo set balance=balance+@bal where accountno=@receiver";
                    cmd.Parameters.AddWithValue("@bal", t.amount);
                    cmd.Parameters.AddWithValue("@receiver", t.recieverAccNo);
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    cmd.CommandText = "update accountinfo set balance=balance-@bal1 where accountno=@sender";
                    cmd.Parameters.AddWithValue("@bal1", t.amount);
                    cmd.Parameters.AddWithValue("@sender", t.senderAccNo);
                    conn.Open();
                    recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    cmd.CommandText = "Insert into transactions(senderaccno,receiveraccno,date,time,amount) values(@senderaccno,@receiveraccno,convert(date,GETDATE()),cast(GETDATE() as time(7)),@amount)";
                    cmd.Parameters.AddWithValue("@senderaccno", t.senderAccNo);
                    cmd.Parameters.AddWithValue("@receiveraccno", t.recieverAccNo);
                    cmd.Parameters.AddWithValue("@amount", t.amount);
                    conn.Open();
                    recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                    return "Successfully Transferred";
                }
            }

        }

    }
    }
