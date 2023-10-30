package billing;

import hcustbackend.ClientACT;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

public class ConfirmBillingPayment_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			 //fetching date
			DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
			Calendar calobj = Calendar.getInstance();
			String today = df.format(calobj.getTime());
			
			boolean flag=false;
			HttpSession session=request.getSession();
			//get addedby by session
			String addedby=(String)session.getAttribute("loginuID");
			//get token no by session
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String payoption=request.getParameter("payoption").trim();
			String pdate=request.getParameter("pdate").trim();
			String transid=request.getParameter("transid").trim();
			String transamt=request.getParameter("transamt").trim();
			String brefid=request.getParameter("brefid").trim();
			String pymtrefid=request.getParameter("pymtrefid").trim();	
			String tablefrom=request.getParameter("tablefrom").trim();
						
			//updating clientbillpayment details
			flag=ClientACT.updateBillingPayment(payoption,pdate,transid,transamt,brefid,pymtrefid,token,tablefrom);
			
			if(flag){
				//getting billing details
				String bill[]=ClientACT.getbillingDetails(brefid,token);
				double dueamt=Double.parseDouble(bill[5])-Double.parseDouble(transamt);
				String pymtstatus="Awaiting Payment";
				if(dueamt==0)pymtstatus="Paid";
				String prjno=Clientmaster_ACT.getProjectNo(bill[6], token);
				//updating billing details
				ClientACT.updateBilling(brefid,pymtstatus,dueamt); 
				//update clientbillmapping table if due amount is 0
				if(dueamt==0){
					//updating clientbillingmapping table status payment received
					ClientACT.updateBillingMappingStatus(brefid,token);					
				
				}
				if(tablefrom.equalsIgnoreCase("billing")){
				//getting all task of project completed orn not status
					int milestone=0;
					int completedtask=0;
					boolean ass_status=false;					
					ass_status=Clientmaster_ACT.getAssignedStatus(prjno,token);
					if(ass_status){
					milestone=Clientmaster_ACT.getAllMileStone(bill[6],token);
					completedtask=Clientmaster_ACT.getAllCompletedTask(prjno,token);	
					if(milestone==completedtask){
						//counting total project price items
						int tppi=Clientmaster_ACT.getCountAllPriceItems(bill[6],token);
						//counting total project price items paid
						int tppip=Clientmaster_ACT.getCountAllPriceItemsPaid(bill[6],token,"billing");
						if(tppi==tppip){
						//getting delivery date of project
						String deliverydate=Clientmaster_ACT.getDeliverdOnDate(bill[6],token);
						if(deliverydate.equalsIgnoreCase("NA")||deliverydate==null)deliverydate=today;
						//update project delivered in project table
						Clientmaster_ACT.updateProjectStatusDelivered(bill[6],bill[1],token); 
						//updating renewal daTE
						Clientmaster_ACT.updateRenewalDate(bill[6],deliverydate,token);	
						}
					}
				}
				//adding statement into client account
				String accbmuid=Clientmaster_ACT.getAccountId(bill[1],token);
				String remarks="Bill payment of Invoice # "+bill[0];
				Clientmaster_ACT.creditBalance(accbmuid,transamt,remarks,pdate,addedby,bill[0],prjno);
				}else if(tablefrom.equalsIgnoreCase("amc")){
					//getting client account id
					String accbmuid=Clientmaster_ACT.getAccountId(bill[1],token);
					//counting total project price items
					int tppi=Clientmaster_ACT.getCountAllAMCPriceItems(bill[6],token);
					//counting total project price items paid
					int tppip=Clientmaster_ACT.getCountAllPriceItemsPaid(bill[6],token,"amc");
					if(tppi==tppip){
					//updating renewal daTE
					Clientmaster_ACT.updateReRenewalDate(bill[6],token);
					//update payment status 2 of clientbillmapping table
					ClientACT.updateAmcBillingMappingStatus(bill[6],token);
					//debit balance of renewal project price
					double totalrenamt=Clientmaster_ACT.getTotalRenewalAmount(bill[6],token);
					String remarks="Debit payment of Invoice # "+bill[0];
					Clientmaster_ACT.debitBalance(accbmuid,totalrenamt,remarks,today,addedby,bill[0],prjno);
					}					
					//adding statement into client account					
					String remarks="Bill payment of Invoice # "+bill[0];
					Clientmaster_ACT.creditBalance(accbmuid,transamt,remarks,pdate,addedby,bill[0],prjno);
				}
				
				//add notification 'bill payment confirmation ...'
				String loginuaid = (String) session.getAttribute("loginuaid");
				String pagename="NA";
				String accesscode="NA";
				if(tablefrom.equalsIgnoreCase("amc")){pagename="amc-account.html";accesscode="AMC00";}
				else if(tablefrom.equalsIgnoreCase("billing")){pagename="manage-billing.html";accesscode="MB07";}
				String clientpage="client_payments.html";
				String uuid =RandomStringUtils.random(30, true, true);	
				String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
				String msg="<b>"+prjno+" : "+bill[0]+"</b> invoice payment confirmed by  <b>"+assignby+"</b>";
				ClientACT.addNotification(uuid, brefid, msg, pagename,tablefrom, "1", bill[1], "1", "1", addedby, token,clientpage, loginuaid,accesscode,"1","1");
			
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
