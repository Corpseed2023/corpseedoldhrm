package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class GetSalesLoginContactsCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String salesKey=request.getParameter("salesKey").trim();
			String data="";
			if(salesKey!=null&&salesKey.length()>0) {
			String clientKey=Enquiry_ACT.getClientKeyBySalesKey(salesKey, token);
			int superUserId=Clientmaster_ACT.findClientSuperUserByKey(clientKey, token);
			if(superUserId>0) {
			String users[][]=Usermaster_ACT.findAllUserBySuperUser(superUserId,token);
			int k=0;
			data+="<input type=\"hidden\" id=\"allUserLogin\" value=\""+(users.length)+"\">";
			String superUser[]=Usermaster_ACT.findUserByUaid(superUserId, token);
			data+="<div class=\"row credential0\">\n"
					+ "<div class=\"form-group-payment col-md-5 col-sm-5 col-5\"><input type=\"hidden\" name=\"loginUaid0\" id=\"loginUaid0\" value=\""+superUserId+"\">\n"
					+ "	 <input type=\"text\" class=\"form-control\" name=\"loginName0\" id=\"loginName0\" value=\""+superUser[0]+"\" required=\"required\" readonly=\"readonly\">\n"
					+ "</div>\n"
					+ "  <div class=\"form-group-payment col-md-6 col-sm-6 col-6\">\n"
					+ "		<input type=\"email\" class=\"form-control\" pattern=\"[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$\" name=\"loginEmail0\" id=\"loginEmail0\" value=\""+superUser[1]+"\" required=\"required\">\n"
					+ "  </div>\n"
					+ "<div class=\"form-group-payment col-md-1 col-sm-1 col-1\" style=\"padding: 0;\">\n"
					+ "	  <button type=\"button\" class=\"btn btn-danger\" onclick=\"removeSendLogin('credential0')\">X</button>\n"
					+ "</div>\n"
					+ "</div>";
				if(users!=null&&users.length>0){					
					for(int j=0;j<users.length;j++){
						k++;
						data+="<div class=\"row credential"+k+"\">\n"
								+ "<div class=\"form-group-payment col-md-5 col-sm-5 col-5\"><input type=\"hidden\" name=\"loginUaid"+k+"\" id=\"loginUaid"+k+"\" value=\""+users[j][0]+"\">\n"
								+ "	 <input type=\"text\" class=\"form-control\" name=\"loginName"+k+"\" id=\"loginName"+k+"\" value=\""+users[j][1]+"\" required=\"required\" readonly=\"readonly\">\n"
								+ "</div>\n"
								+ "  <div class=\"form-group-payment col-md-6 col-sm-6 col-6\">\n"
								+ "		<input type=\"email\" class=\"form-control\" pattern=\"[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,4}$\" name=\"loginEmail"+k+"\" id=\"loginEmail"+k+"\" value=\""+users[j][2]+"\" required=\"required\">\n"
								+ "  </div>\n"
								+ "<div class=\"form-group-payment col-md-1 col-sm-1 col-1\" style=\"padding: 0;\">\n"
								+ "	  <button type=\"button\" class=\"btn btn-danger\" onclick=\"removeSendLogin('credential"+k+"')\">X</button>\n"
								+ "</div>\n"
								+ "</div>";						
					}
				}
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