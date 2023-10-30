package hcustbackend;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;


public class PaymentBillCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request,HttpServletResponse response)throws ServletException,IOException{
		RequestDispatcher rd=request.getRequestDispatcher("/client_payments.html");
		rd.forward(request, response);
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		 //fetching date
//		DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
//		Calendar calobj = Calendar.getInstance();
//		String today = df.format(calobj.getTime());	
		//get addedby by session
		String addedby=(String)session.getAttribute("loginuID");
		//get token no by session
		String token=(String)session.getAttribute("uavalidtokenno");
		String loginuaid = (String) session.getAttribute("loginuaid");
		String payoption=request.getParameter("payoption");	
		
		String pdate=request.getParameter("pdate");
		if(pdate!=null)pdate=pdate.trim();
		
		String transid=request.getParameter("transid");
		if(transid!=null)transid=transid.trim();
		
		String transamt=request.getParameter("transamt");
		if(transamt!=null)transamt=transamt.trim();
		
		String billrefid=request.getParameter("brefid");
		if(billrefid!=null)billrefid=billrefid.trim();
		
		String requestfrom=request.getParameter("rfrom");
		if(requestfrom!=null)requestfrom=requestfrom.trim();
		
		String bill[]=ClientACT.getbillingDetails(billrefid,token);
		String key =RandomStringUtils.random(30, true, true);	
		ClientACT.addBillPayment(bill[0],bill[1],bill[2],token,addedby,payoption,pdate,transid,transamt,billrefid,key);
		
		//add notification 'payment received of invoice ...'
		String pagename="NA";
		String accesscode="NA";
		String uuid =RandomStringUtils.random(30, true, true);
		if(bill[2].equalsIgnoreCase("billing")){pagename="manage-billing.html";accesscode="MB07";}
		else if(bill[2].equalsIgnoreCase("amc")){pagename="amc-account.html";accesscode="AMC00";}
		String clname=ClientACT.getClientName(bill[1], token);
		String msg="<b>"+clname+"</b> paid Payment of invoice number : "+bill[0];
		ClientACT.addNotification(uuid,billrefid,msg,pagename,bill[2],"0",bill[1],"1","1",addedby,token,"NA",loginuaid,accesscode,"1","0");
		
		if(requestfrom.equalsIgnoreCase("Client")){
		RequestDispatcher rd=request.getRequestDispatcher("/client_payments.html");
		rd.forward(request, response);
		}
	}

}
