package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.enquiry.Enquiry_ACT;

public class SendSmsEmailNotification_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4130059693338567572L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		//for sms
		String smsPhone = request.getParameter("smsPhone").trim();
		String smsDescription = request.getParameter("smsDescription").trim();
		//for email
		String emailTo = request.getParameter("emailTo").trim();
		String emailSubject = request.getParameter("emailSubject").trim();
		String emailDescription = request.getParameter("emailDescription").trim();
		HttpSession session = request.getSession(); 
		String token=(String)session.getAttribute("uavalidtokenno");
		//sending email
		Enquiry_ACT.saveEmail(emailTo,"empty",emailSubject, emailDescription,2,token);
	}

}