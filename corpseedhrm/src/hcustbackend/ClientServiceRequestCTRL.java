package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.CommonHelper;

public class ClientServiceRequestCTRL extends HttpServlet {

	private static final long serialVersionUID = -2467308169438357L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 			
			String category=request.getParameter("category");
			String token = (String)session.getAttribute("uavalidtokenno");
			String client_id = (String)session.getAttribute("loginClintUaid");
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String POST_URL=properties.getProperty("Bitrix24")+"crm.lead.add.json";
			
			if(client_id!=null&&client_id.length()>0) {
				String client[][]=ClientACT.getClientDetails(token,client_id);
				if(client!=null&&client.length>0) {
					
					String POST_PARAMS="";
					String comment="Contact Person : "+client[0][3]+" "+client[0][4]+"\nCity : "+client[0][2]+"\nAddress : "+client[0][2];
					String email=client[0][5];
					String title=category+" (Client)";
					String company=client[0][0];
					String mobile=client[0][6];
					if(comment==null||comment.length()<=0)comment="NA";
					if(email!=null&&!email.equalsIgnoreCase("NA")&&email.length()>0)
						POST_PARAMS = "FIELDS[TITLE]="+title+"&FIELDS[NAME]="+company+"&FIELDS[EMAIL][0][VALUE]="+email+"&FIELDS[PHONE][0][VALUE]="+mobile+"&FIELDS[COMMENTS]="+comment;
					else
						POST_PARAMS = "FIELDS[TITLE]="+title+"&FIELDS[NAME]="+company+"&FIELDS[PHONE][0][VALUE]="+mobile+"&FIELDS[COMMENTS]="+comment;
					int res=400;
					try {						
						res = CommonHelper.callPostURL(POST_URL, POST_PARAMS);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
//					System.out.println("Response==="+res);
					if(res==200) {	
						pw.write("pass");
					}else pw.write("fail");
					
				}
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}