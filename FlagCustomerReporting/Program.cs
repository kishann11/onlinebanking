using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;

namespace FlaggedCustomerReporting
{
    class Program
    {
        string strFilePath = @"C:\Users\Nexwave\Desktop\Reports\Report.csv";
        String connectionString = "Data Source=tcp:192.168.14.106,40000;Initial Catalog=OnlineBanking;Integrated Security=True";
        SqlConnection conn;
        SqlDataReader rdr;
        SqlCommand cmd;
        String sql;
        private DataTable dataTable = new DataTable();

        public void CreateCSVFile(DataTable dtDataTablesList, string strFilePath)

        {
            // Create the CSV file to which grid data will be exported.

            StreamWriter sw = new StreamWriter(strFilePath, false);

            //First we will write the headers.

            int iColCount = dtDataTablesList.Columns.Count;

            for (int i = 0; i < iColCount; i++)
            {
                sw.Write(dtDataTablesList.Columns[i]);
                if (i < iColCount - 1)
                {
                    sw.Write(",");
                }
            }
            sw.Write(sw.NewLine);

            // Now write all the rows.

            foreach (DataRow dr in dtDataTablesList.Rows)
            {
                for (int i = 0; i < iColCount; i++)
                {
                    if (!Convert.IsDBNull(dr[i]))
                    {
                        sw.Write(dr[i].ToString());
                    }
                    if (i < iColCount - 1)

                    {
                        sw.Write(",");
                    }
                }
                sw.Write(sw.NewLine);
            }
            sw.Close();
        }



        public void RunStoredProc()
        {
            conn = null;
            rdr = null;
            try
            {
                conn = new SqlConnection(connectionString);
                conn.Open();
                cmd = new SqlCommand("dbo.UPDATIONTABLEFINAL10", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                rdr = cmd.ExecuteReader();
            }
            finally
            {
                if (conn != null)
                {
                    conn.Close();
                }
                if (rdr != null)
                {
                    rdr.Close();
                }
            }
        }

        public void PullData()
        {
            
            sql = "select * from flaggedcustomers";

            conn = new SqlConnection(connectionString);
            cmd = new SqlCommand(sql, conn);
            conn.Open();

            // create data adapter
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            // this will query your database and return the result to your datatable
            da.Fill(dataTable);
            conn.Close();
            da.Dispose();
        }

        public void EmptyTable()
        {
            sql = "delete from flaggedcustomers";
            conn = new SqlConnection(connectionString);
            cmd = new SqlCommand(sql, conn);
            conn.Open();
            cmd.ExecuteNonQuery();
            conn.Close();
        }

        static void Main(string[] args)
        {

            Program p = new Program();
            p.RunStoredProc();
            p.PullData();
            p.CreateCSVFile(p.dataTable,p.strFilePath);
            p.EmptyTable();
            var m = new Mailer();
            m.SendEmail();
            
         }
    }
}
