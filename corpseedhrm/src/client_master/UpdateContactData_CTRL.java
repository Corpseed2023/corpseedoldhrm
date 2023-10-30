package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;

@SuppressWarnings("serial")
public class UpdateContactData_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		boolean status = false;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		
try{
		String firstname = request.getParameter("firstname").trim();
		String lastname = request.getParameter("lastname").trim();
		String email =request.getParameter("email").trim();
		String email2 = request.getParameter("email2").trim();
		String workphone = request.getParameter("workphone").trim();		
		String mobile =request.getParameter("mobile").trim();		
		String city=request.getParameter("city").trim();
		String state = request.getParameter("state").trim();		
		String country = request.getParameter("country").trim();	
		String pan = request.getParameter("pan").trim();	
		String address =request.getParameter("address").trim();		
		String companyaddress=request.getParameter("companyaddress").trim();	
		String addresstype = request.getParameter("addresstype").trim();
		String contkey =request.getParameter("contkey").trim();
		String clientkey =request.getParameter("clientkey").trim();
		if(addresstype.equalsIgnoreCase("Company")){
			address=companyaddress;
			city="NA";
			state="NA";
		}
		String compName =request.getParameter("compName").trim();
		
		//updating contact details
		status=Clientmaster_ACT.updateContactData(compName,clientkey,contkey,firstname,lastname,email,email2,workphone,mobile,city,state,addresstype,address,token,country,pan);
		if(status)pw.write("pass");
		else pw.write("fail");
}catch(Exception e){
			log.info("Error in UpdateContactDetails_CTRL \n"+e);
		}	
	}

}
