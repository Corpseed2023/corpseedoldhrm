package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class DeclineSalePaymentCTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();		
try{		
	boolean status=false;
		String token = (String) session.getAttribute("uavalidtokenno");	
		String loginuaid = (String)session.getAttribute("loginuaid");
		String billingDoAction=(String)session.getAttribute("billingDoAction");
		if(billingDoAction==null||billingDoAction.length()<=0)billingDoAction="All";
		String refid=request.getParameter("refid").trim();
		String comment=request.getParameter("comment").trim();
		String today=DateUtil.getCurrentDateIndianFormat1();
		String invoiceno=request.getParameter("invoiceno").trim();
		double amount=Enquiry_ACT.getTransactionAmount(refid,token);		
		//updating billing details with invoice and reduce transaction amount and amount in paid amount
		if(!billingDoAction.equalsIgnoreCase("Hold"))
		status=Enquiry_ACT.updateBillingDeclineAmount(invoiceno,amount,token);
		else
			status=Enquiry_ACT.updateHoldBillingDeclineAmount(invoiceno,amount,token);
		//decline payment
		status=Enquiry_ACT.declinePayment(refid,loginuaid,today,token,comment);
		
		if(status){
			//adding notification
			String nKey=RandomStringUtils.random(40,true,true);			
			String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);			
			String message="Payment of rs. "+amount+" is <b class='text-danger'>declined</b> against sales invoice :"+invoiceno+" by &nbsp;<span class='text-muted'>"+userName+"</span>";
			
			String showUaid=Enquiry_ACT.getSalesSoldByUaid(invoiceno,token);
			if(showUaid==null||showUaid.equalsIgnoreCase("NA"))
				showUaid=Enquiry_ACT.getEstimateSalesSoldByUaid(invoiceno, token);
			
			TaskMaster_ACT.addNotification(nKey,today,showUaid,"2","manage-sales.html",message,token,loginuaid,"fas fa-rupee-sign");
			
			
			String soldUid=Enquiry_ACT.getEstimateSalesSoldByUaid(invoiceno, token);
			if(soldUid==null||soldUid.equalsIgnoreCase("NA"))
				soldUid=Enquiry_ACT.getSalesSoldByUaid(invoiceno, token);
			
			String[][] user=Usermaster_ACT.getUserByID(soldUid);
			String name="";
			String email="";
			if(user!=null&&user.length>0) {
				name=user[0][5];
				email=user[0][7];
			}
			String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">"
					+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">"
					+ "                <a href=\"#\" target=\"_blank\"><img src=\"https://corpseed.com/assets/img/logo.png\"></a></td></tr>"
					+ "            <tr><td style=\"text-align: center;\">"
					+ "                <h1>ORDER UPDATE</h1>\n"
					+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>"
					+ "        <tr><td style=\"padding:70px 0 20px;color: #353637;\">"
					+ "            Hi "+name+",</td></tr>"
					+ "             <tr><td style=\"padding: 10px 0 15px;color: #353637;\">"
					+ "                     <p> Payment of Rs. <b>"+amount+"</b> added on Invoice/Estimate <b>"+invoiceno+"</b> is <span style=\"color:#d91f16\">Declined</span>, For any query plase contact account department.."
					+ "                      </p></td></tr>"
					+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">"
					+ "                <b>Invoice/Estimate : #"+invoiceno+"</b><br>"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p></td></tr></table>";
			
			if(email!=null&&email.length()>0&&!email.equalsIgnoreCase("NA"))
				Enquiry_ACT.saveEmail(email,"empty","Payment Declined | Corpseed", message1,2,token);
			
			
			pw.write("pass");
		}else{
			pw.write("fail");
		}
}catch(Exception e){e.printStackTrace();
	log.info("Error in admin.enquiry.UpdateTransactionAmountCTRL \n"+e);
}
	
	}

}
