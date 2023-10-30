package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SendSalesInvoice_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5343230968235415196L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		
		boolean sendEmail =false;
		try {
			HttpSession session=request.getSession();
			String sendto=request.getParameter("emailTo");
			if(sendto!=null)sendto=sendto.trim();
			
			String emailCC=request.getParameter("CC");
			if(emailCC!=null)emailCC=emailCC.trim();
			
			String emailSubject=request.getParameter("emailSubject");
			if(emailSubject!=null)emailSubject=emailSubject.trim();
			
			String emailBody=request.getParameter("emailBody");
			if(emailBody!=null)emailBody=emailBody.trim();
			
			String token=(String)session.getAttribute("uavalidtokenno");
//			System.out.println("SendSalesInvoice_CTRL="+emailCC);
			Enquiry_ACT.saveEmail(sendto,emailCC,emailSubject, emailBody,2,token);
			
//			if(sendEmail) {
//			//adding estimate notification
//			String estremarks="<span style='color:#5757ea'>Invoice sended</span>";
//			String estKey=RandomStringUtils.random(40,true,true);
//			Clientmaster_ACT.saveEstimateNotification(estKey,salesNo,loginuaid,estremarks,today,token);
//				
//				}
			 if(sendEmail) {
				 out.write("pass");
			 }else {
				 out.write("fail");
			 }
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}