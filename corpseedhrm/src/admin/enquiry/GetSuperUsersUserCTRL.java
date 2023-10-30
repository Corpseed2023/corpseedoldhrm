package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

@SuppressWarnings("serial")
public class GetSuperUsersUserCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
			String domain=properties.getProperty("domain");
			
			String uaid=request.getParameter("uaid").trim();
			if(uaid==null||uaid.length()<=0)uaid="0";
			String data="";
			if(uaid!=null&&uaid.length()>0) {
			String users[][]=Usermaster_ACT.findAllUserBySuperUser(Integer.parseInt(uaid), token);
			if(users!=null&&users.length>0){				
				for(int j=0;j<users.length;j++){
					data+="<div class=\"row\"><div class=\"col-sm-9\">"+users[j][1]+"</div><div class=\"col-sm-3\"><a href=\""+domain+"user-sales-permission.html?id="+users[j][0]+"\" target=\"_blank\">Permissions</a></div></div>";
				}
				data+="</ul>";
			}else {
				data="<div class=\"text-danger text-center\">No Data Found</div>";
			}
			}	
//			System.o ut.println(data);
			out.write(data);
		}
		catch (Exception e) {
				e.printStackTrace();
		}

	}
}