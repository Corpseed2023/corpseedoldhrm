package admin.task;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class SendResetLink_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = -4130059693338567572L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String domain=properties.getProperty("domain");
		
		String username = request.getParameter("userId").trim();
		String user[]=Usermaster_ACT.isValidUser(username);
		if(user[0]!=null&&!user[0].equalsIgnoreCase("NA")) {			
			String key=RandomStringUtils.random(40,true,true);
			String link=domain+"reset-password.html?ufp="+user[3]+"&fpk="+key;
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			boolean isExpired=TaskMaster_ACT.isLinkExpired(user[3],date);
			if(isExpired) {
			//saving forget password details in forget password table
			boolean flag=TaskMaster_ACT.saveForgetPasswordLink(key,
					link,date,user[3]);
			if(flag) {
				String message="<p>Hi &nbsp;"+user[1]+"</p><p>We received a request for a password change on your <a href='"+domain+"'>crm.corpseed.com</a> account. You can reset your password <a href='"+link+"' style='color:blue'>here</a>.</p>"+
						"<p>This link will expire tomorrow.After that,you'll need to submit a new request in order to reset your password. If you don't want to reset it, Simply disregard this email.</p><p>If you need more help or believe this email was sent in error, feel free to <a href='mailto:hello@corpseed.com'>Contact Us</a>.</p>"+
								"<p>(Please don't reply to this message,It's automated.)</p><p>Thanks,</p><p>corpseed.com</p>";
				Enquiry_ACT.saveEmail(user[0],"empty","Password Reset | Corpseed", message,2,user[2]);
				
				session.setAttribute("forgeterrormsg", "Reset your password clicking on email link !!");
				session.setAttribute("forgeterrorclass", "text-success");
			}
			}else {
				session.setAttribute("forgeterrormsg", "Reset your password clicking on email link !!");
				session.setAttribute("forgeterrorclass", "text-success");
			}
			
		}else {
			session.setAttribute("forgeterrormsg", "Please enter a valid username !!");
			session.setAttribute("forgeterrorclass", "text-danger");			
		}
		response.sendRedirect("forget-password.html");
	}

}