package admin.master;

import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import commons.DateUtil;

public class SaveClientSuperUser_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{  
	HttpSession session =request.getSession();	
	PrintWriter out=response.getWriter();
	String token = (String)session.getAttribute("uavalidtokenno");
	String addedby = (String)session.getAttribute("loginuID");
	String company=(String)session.getAttribute("uacompany");
	String today=DateUtil.getCurrentDateIndianReverseFormat();
	
	String super_name = request.getParameter("super_name").trim();
	String super_email = request.getParameter("super_email").trim();
	String super_mobile = request.getParameter("super_mobile").trim();
	
	boolean isExist=Usermaster_ACT.findUserByMobileOrEmail(super_mobile,super_email);
	if(isExist) { 
		out.write("exist");
	}else {
		String uaempid="SU"+today.replace("-", "")+System.currentTimeMillis();
		String password=RandomStringUtils.random(8,true,true);
		String userKey=RandomStringUtils.random(40,true,true);
		boolean flag=Usermaster_ACT.saveClientSuperUser(uaempid,super_mobile,token,password,super_name,super_email,addedby,company,userKey);		
		if(flag) {
			
			String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
					+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
					+ "                <a href=\"#\" target=\"_blank\">\n"
					+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
					+ "            </td></tr>\n"
					+ "            <tr>\n"
					+ "              <td style=\"text-align: center;\">\n"
					+ "                <h1>Login Credentials</h1>"					
					+ "              </td></tr>"
					+ "        <tr>\n"
					+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
					+ "            Hi "+super_name+",</td></tr>"
					+ "             <tr>\n"
					+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
					+ "                     <p> Thank you for choosing Corpseed for your business.\n"					
					+ "                    <p style=\"line-height: 35px;\">Your Admin login credentials :-<br>Username :- "+super_mobile+"<br>Password :- "+password+"</p>"
					+ "						<p><b>Note:-</b> Please don\"t share these credentials with anyone.</p></td></tr>  \n"
				
					+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
					+ "    </td></tr> \n"
					+ "    </table>";
			
			Enquiry_ACT.saveEmail(super_email,"empty","Corpseed | Admin Login credentials", message,2,token); 
			
			out.write("pass");
		}
		else
			out.write("fail");
	}

}catch (Exception e) {
	e.printStackTrace();
}
}

}