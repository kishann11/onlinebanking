using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace OnlineBanking.Helpers
{
    public class Password
    {
        public string GeneratePassword()
        {
            const string validChars = "abcdefghijklmnopqrstuvwxyz";
            const string validChars1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            const string validChars2 = "1234567890";
            const string validChars3 = "#?!@$%^&*-";

            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            int length = 8;

            res.Append(validChars[rnd.Next(validChars.Length)]);
            res.Append(validChars1[rnd.Next(validChars1.Length)]);
            res.Append(validChars3[rnd.Next(validChars3.Length)]);
            while (3 < length--)
            {
                res.Append(validChars2[rnd.Next(validChars2.Length)]);
            }

            return res.ToString();
        }
    }
}