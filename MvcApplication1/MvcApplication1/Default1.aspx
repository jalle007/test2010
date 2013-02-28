<%@ Page Language="C#"%>
<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Web.Script.Serialization" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<script runat="server">
    protected void Page_Load(object sender, EventArgs ec)
    {
        // Data Source=(localdb)\v11.0;AttachDbFilename=C:\Users\jibrisimbegovic\Documents\GitHub\SQLsync\App_Data\SQLsync.mdf;Integrated Security=True
        // @"Data Source=DL-ND-02\SQL2K8R2;Initial Catalog=Umbraco;Persist Security Info=True;User ID=Umbraco;Password=Umbraco"
        var conStr = @"Server=3be116aa-a6ab-479e-8e38-a1730147d5fe.sqlserver.sequelizer.com;Database=db3be116aaa6ab479e8e38a1730147d5fe;User ID=sjnkozpqwghseqih;Password=zogU5cpfWjLXp4dpKFZS8pnXYcskPPmChAHCQpEQgzKysUw8mcgLVHtjar52Sexg;";
        
        using (SqlConnection cn = new SqlConnection(conStr)) 
        {
            using (StreamReader sr = new StreamReader(Request.InputStream, Encoding.UTF8))
            {
                Response.ContentType = "text/plain";
                string c;
                c = Request.QueryString["query"]; //for debugging with the browser you can set the query by adding the query parameter  For ex: <a href="http://127.0.0.1/test.aspx?query=select" target="_blank">http://127.0.0.1/test.aspx?query=select</a> * from table1
                if (c == null)
                {
                    c = "SELECT 10 AS Expr1";
                    c = sr.ReadToEnd();
                }
                
                else
                {
                    // c = sr.ReadToEnd();
                }
                
                try
                {
                    SqlCommand cmd = new SqlCommand(c, cn);
                    cn.Open();
                    SqlDataReader rdr = cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    List<Dictionary<string, object>> list = new List<Dictionary<string, object>>();
                    while (rdr.Read())
                    {
                        Dictionary<string, object> d = new Dictionary<string, object>(rdr.FieldCount);
                        for (int i =0;i < rdr.FieldCount;i++)
                        {
                            d[rdr.GetName(i)] = rdr.GetValue(i);
                        }
                        list.Add(d);
                    }
                    JavaScriptSerializer j = new JavaScriptSerializer();
                    Response.Write(j.Serialize(list.ToArray()));
                    
                } catch (Exception e)
                {
                    Response.TrySkipIisCustomErrors = true;
                    Response.StatusCode = 500;
                    Response.Write("Error occurred. Query=" + c + "\n");
                    Response.Write(e.ToString());
                    
                }
                Response.End();
            }
        }
    }
</script>
<form id="form1" runat="server">
</form>

