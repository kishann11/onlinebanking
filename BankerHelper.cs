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
    public class BankerHelper
    {
        private String connectionString = "Data Source=tcp:192.168.14.106,40000;Initial Catalog=OnlineBanking;Integrated Security=True";
        private SqlConnection conn;
        private SqlDataReader rdr;
        private SqlCommand cmd;
        private String sql;
        private SqlDataReader rdr1;

        internal bool BankerLogin(Login obj)
        {
            sql = "SELECT bankerid,lastlogin FROM bankerlogin where bankerid="+obj.id+" and pass=HASHBYTES('SHA2_512','"+obj.password+"')";

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        HttpContext.Current.Session["lastlogin"] = rdr["lastlogin"];
                        HttpContext.Current.Session["bankerid"] = rdr["bankerid"];
                        conn.Close();
                        return true;
                    }
                    conn.Close();
                    return false;
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
                    cmd.CommandText = "update bankerlogin set lastlogin=CONVERT(smalldatetime,GETDATE()) where bankerid=" + obj.id;
                  
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }

        internal CustomerDetails FetchDetails(CustomerDetails obj)
        {
            sql = "SELECT firstname,lastname,CONVERT(varchar(12),dob,120) as dob,homeaddress,emailid,phoneno FROM customerinfo where customerid="+obj.cid;
            HttpContext.Current.Session["customerid"] = obj.cid;
            using (conn = new SqlConnection(connectionString))
            {
                cmd = new SqlCommand(sql, conn);
                conn.Open();
                var c = new CustomerDetails();
                rdr = cmd.ExecuteReader();
                while (rdr.Read())
                {
                    
                    c.firstName = rdr["firstname"].ToString();
                    c.lastName = rdr["lastname"].ToString();
                    c.dateOfBirth =rdr["dob"].ToString();
                    c.address = rdr["homeaddress"].ToString();
                    c.email = rdr["emailid"].ToString();
                    c.phone = long.Parse(rdr["phoneno"].ToString());
                   
            }
                conn.Close();
                return c;
            }

        }

        internal void UpdateCustomer(CustomerDetails obj)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;
                    cmd.CommandText = "update customerinfo set firstname=@fname,lastname=@lname,dob=@dob,homeaddress=@address,emailid=@email,phoneno=@phno where customerid="+obj.cid;
                    cmd.Parameters.AddWithValue("@fname", obj.firstName);
                    cmd.Parameters.AddWithValue("@lname", obj.lastName);
                    cmd.Parameters.AddWithValue("@phno", obj.phone);
                    cmd.Parameters.AddWithValue("@email", obj.email);
                    cmd.Parameters.AddWithValue("@address", obj.address);
                    cmd.Parameters.AddWithValue("@dob", obj.dateOfBirth);

                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();
                }
            }
        }


        internal bool CheckCreditScore(CustomerDetails obj)
        {

            sql = "SELECT creditscore from creditscore where ssn=" + obj.cid;

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        if(int.Parse(rdr["creditscore"].ToString())>=750)
                        {
                            conn.Close();
                            return true;
                        }
                        else
                        {
                            conn.Close();
                            return false;
                        }
                       
                    }
                    else
                    {
                                 conn.Close();
                                cmd.Connection = conn;            // <== lacking
                                cmd.CommandType = CommandType.Text;
                                cmd.CommandText = "INSERT into creditscore(creditscore,ssn) VALUES (1000,@ssn)";
                                cmd.Parameters.AddWithValue("@ssn", obj.cid);
                                 conn.Open();
                                int recordsAffected = cmd.ExecuteNonQuery();
                                conn.Close();
                                return true;
                     
                    }
                }
            }

        }

        internal void RegisterCustomer(CustomerDetails obj)
        {
            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand())
                {
                    cmd.Connection = conn;            // <== lacking
                    cmd.CommandType = CommandType.Text;

                    var p = new Password();
                    var pwd = p.GeneratePassword();
                    cmd.CommandText = "INSERT into customerinfo(firstname,lastname,pass,phoneno,dob,emailid,homeaddress,ssn) VALUES (@fname, @lname,HASHBYTES('SHA2_512','"+pwd+"'),@phno,@dob,@email,@address,@ssn)";
                    cmd.Parameters.AddWithValue("@fname", obj.firstName);
                    cmd.Parameters.AddWithValue("@lname", obj.lastName);
                    cmd.Parameters.AddWithValue("@phno", obj.phone);
                    cmd.Parameters.AddWithValue("@email", obj.email);
                    cmd.Parameters.AddWithValue("@address", obj.address);
                    cmd.Parameters.AddWithValue("@ssn", obj.cid);
                    cmd.Parameters.AddWithValue("@dob", obj.dateOfBirth);
                    conn.Open();
                    int recordsAffected = cmd.ExecuteNonQuery();
                    conn.Close();

                            string sql1 = "SELECT customerid from customerinfo where ssn="+obj.cid;
                            conn.Open();
                           cmd = new SqlCommand(sql1, conn);
                            rdr1 = cmd.ExecuteReader();
                             rdr1.Read();
                            var cid = rdr1["customerid"].ToString();
                                conn.Close();

                                var m = new MailModel();
                                m.toAddress = obj.email;
                                m.subject = "Welcome to Peoples Bank";
                                m.body = "Your CustomerId is:" + cid +" and your one time password is:"+pwd;
                                var e = new Mail();
                                e.SendEmail(m);

                }
            }
        }

        internal string AddAccount(CustomerDetails c, Accounts a)
        {
            sql = "SELECT count(accountno) as count from accountinfo where customerid=" + c.cid + " and accounttype='" + a.accountType + "'";

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    rdr.Read();
                    if (int.Parse(rdr["count"].ToString()) >= 5)
                    {
                        conn.Close();
                        return "Account Limit Exceeded";
                    }

                    else
                    {
                        conn.Close();
                        cmd.Connection = conn;            // <== lacking
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "INSERT into accountinfo(accounttype,customerid,balance,dateofcreation) VALUES (@accounttype,@cid,@balance,CONVERT(date,GETDATE()))";
                        cmd.Parameters.AddWithValue("@accounttype", a.accountType);
                        cmd.Parameters.AddWithValue("@cid", c.cid);
                        cmd.Parameters.AddWithValue("@balance", a.balance);
                        try
                        {
                            conn.Open();
                            int recordsAffected = cmd.ExecuteNonQuery();
                            conn.Close();
                            return "Successfully Added";
                        }
                        catch
                        {
                            conn.Close();
                            return "Invalid CustomerId";
                        }
                    }
                }
            }
        }


        internal string CloseAccount(Accounts a)
        {
            sql = "SELECT balance from accountinfo where accountno=" + a.accountNum+"and flag=1";

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if(rdr.Read())
                    {
                        if(double.Parse(rdr["balance"].ToString()) ==0)
                        {
                            conn.Close();
                            cmd.Connection = conn;            // <== lacking
                            cmd.CommandType = CommandType.Text;
                            cmd.CommandText = "update accountinfo set flag=0 where accountno=" + a.accountNum;
                                conn.Open();
                                int recordsAffected = cmd.ExecuteNonQuery();
                                conn.Close();
                                return "Account Closed Successfully";
                        }
                        else
                        {
                            conn.Close();
                            return "Balance is not zero";
                        }
                    }
                    else
                    {
                        conn.Close();
                        return "Invalid Account Number";
                    }

                    
                    }
                }
            }

        internal string DeactivateCustomer(CustomerDetails c)
        {
            sql = "SELECT customerid from customerinfo where customerid=" + c.cid + "and stat=1"; ;

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    if (rdr.Read())
                    {
                        conn.Close();
                        sql = "SELECT count(accountno) as noOfAccs from accountinfo where customerid=" + c.cid + "and flag=1";
                        cmd = new SqlCommand(sql, conn);
                        conn.Open();
                        rdr = cmd.ExecuteReader();
                        rdr.Read();
                         if (int.Parse(rdr["noOfAccs"].ToString()) != 0)
                        {
                            int x = int.Parse(rdr["noOfAccs"].ToString());
                            conn.Close();
                            return "Cannot Deactivate! Customer has " + x + " active accounts";
                        }

                        else
                        {
                            conn.Close();
                            cmd.Connection = conn;            // <== lacking
                            cmd.CommandType = CommandType.Text;
                            cmd.CommandText = "update customerinfo set stat=0 where customerid=" + c.cid;
                            conn.Open();
                            int recordsAffected = cmd.ExecuteNonQuery();
                            conn.Close();
                            return "Customer Deactivated Successfully";
                        }
                    }

                    else
                    {
                        conn.Close();
                        return "Invalid CustomerId";

                    }
                }
            }
        }


        public string FetchSSN(CustomerDetails c)
        {
            sql = "SELECT ssn from customerinfo where customerid=" + c.cid;

            using (conn = new SqlConnection(connectionString))
            {
                using (cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();
                    rdr = cmd.ExecuteReader();
                    rdr.Read();
                    var ssn= rdr["ssn"].ToString(); 
                    conn.Close();
                    return ssn;
                    
                }
            }
        }



    }
}