package billing;

import hcustbackend.ClientACT;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

public class FraudTransaction_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			HttpSession session=request.getSession();
			//get addedby by session
			String addedby=(String)session.getAttribute("loginuID");
			//get token no by session
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String pymtrefid=request.getParameter("val").trim();
			String tablefrom=request.getParameter("type").trim();
			String brefid=request.getParameter("brefid").trim();
			
			boolean flag=Clientmaster_ACT.deleteFraudTransaction(pymtrefid);	
			if(flag){
				String bill[]=ClientACT.getbillingDetails(brefid,token);
				String prjno=Clientmaster_ACT.getProjectNo(bill[6], token);
				//add notification 'decline bill payment confirmation ...'
				String loginuaid = (String) session.getAttribute("loginuaid");
				String pagename="NA";
				String accesscode="NA";
				if(tablefrom.equalsIgnoreCase("amc")){pagename="amc-account.html";accesscode="AMC00";}
				else if(tablefrom.equalsIgnoreCase("billing")){pagename="manage-billing.html";accesscode="MB07";}
				String clientpage="client_payments.html";
				String uuid =RandomStringUtils.random(30, true, true);	
				String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
				String msg="<b>"+prjno+" : "+bill[0]+"</b> invoice payment decliend by  <b>"+assignby+"</b>";
				ClientACT.addNotification(uuid, brefid, msg, pagename,tablefrom, "1", bill[1], "1", "1", addedby, token,clientpage, loginuaid,accesscode,"1","1");
			
			}			
		}catch (Exception e) {
		e.printStackTrace();
		}
	}

}
