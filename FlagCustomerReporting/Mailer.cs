using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace FlaggedCustomerReporting
{
    class Mailer
    {
        public void SendEmail()
        {
            MailMessage mail = new MailMessage();
            SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");
            mail.From = new MailAddress("chinthareddysaiteja@gmail.com");
            mail.To.Add("nikithareddyt.2307@gmail.com");
            mail.Subject = "Report of Flagged Users";
            mail.Body = "Flagged users of date:"+ DateTime.Today.ToString("dd-MM-yyyy"); ;

            Attachment attachment;
            attachment = new Attachment("C:/Users/Nexwave/Desktop/Reports/Report.csv");
            mail.Attachments.Add(attachment);

            SmtpServer.Port = 587;
            SmtpServer.Credentials = new System.Net.NetworkCredential("chinthareddysaiteja@gmail.com", "nani1324");
            SmtpServer.EnableSsl = true;
            SmtpServer.Send(mail);

        }
    }
}
