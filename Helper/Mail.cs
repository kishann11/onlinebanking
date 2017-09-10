using OnlineBanking.Data;
using System;
using System.Net.Mail;

namespace OnlineBanking.Helpers
{
    public class Mail
    { 
            public void SendEmail(MailModel m)
             { 
                MailMessage mail = new MailMessage();
                SmtpClient SmtpServer = new SmtpClient("smtp.gmail.com");
                mail.From = new MailAddress("chinthareddysaiteja@gmail.com");
                mail.To.Add(m.toAddress);
                mail.Subject = m.subject;
                mail.Body = m.body;
                SmtpServer.Port = 587;
                SmtpServer.Credentials = new System.Net.NetworkCredential("chinthareddysaiteja@gmail.com", "nani1324");
                SmtpServer.EnableSsl = true;
                SmtpServer.Send(mail);

            }
        }
 }
