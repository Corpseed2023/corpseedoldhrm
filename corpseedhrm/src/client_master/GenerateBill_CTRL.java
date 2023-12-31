package client_master;

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
import hcustbackend.ClientACT;

@SuppressWarnings("serial")
public class GenerateBill_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			 //fetching date
			DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
			Calendar calobj = Calendar.getInstance();
			String today = df.format(calobj.getTime());
			
			double discount=0;
			double finalamount=0;
			String key =RandomStringUtils.random(30, true, true);			
			String addeduser=(String)session.getAttribute("loginuID");
			String cuid=request.getParameter("cuid").trim();			
			String token=(String)session.getAttribute("uavalidtokenno");
			String initial = Usermaster_ACT.getStartingCode(token,"imbillingkey");
			String loginuaid = (String) session.getAttribute("loginuaid");
			String billno=Clientmaster_ACT.getbillingcode(token);
			if (billno==null) {
				billno=initial+"1";
			}
			else {	
				String c=billno.substring(initial.length());	
				int j=Integer.parseInt(c)+1;
				billno=initial+Integer.toString(j);
			}
			if(cuid!=""||cuid!=null){
				String preguid="NA";
				String duedate="NA";
				String bill[][]=Clientmaster_ACT.getItemDetails(cuid,token,"billing");
			if(bill.length>0&&bill!=null){
				int j=1;
				for(int i=0;i<bill.length;i++){					
				discount+=Double.parseDouble(bill[i][4]);
				finalamount+=Double.parseDouble(bill[i][5]);
				String key1 =RandomStringUtils.random(30, true, true);
				//inserting into clientbillingmapping
				Clientmaster_ACT.updateBillGenerate(key1,bill[i][1],billno,token,"billing",key,addeduser,bill[i][2]);
				//deleting virtual table detail by id
				Clientmaster_ACT.deleteVirtualBillingDetails(bill[i][0], token);
				if(j==1){
					preguid=bill[i][2];
					duedate=bill[i][6];
				}
				}
				Clientmaster_ACT.generateBiling(key,billno,cuid,"billing",finalamount,discount,addeduser,today,token,preguid,duedate);
				//add notification 'bill generated ...'
				String prjno=ClientACT.getProjectNo(preguid,token);
				String clname=ClientACT.getClientName(cuid, token);
				String pagename="manage-billing.html";
				String accesscode="MB07";
				String clientpage="client_payments.html";
				String uuid =RandomStringUtils.random(30, true, true);	
				String assignby=Usermaster_ACT.getLoginUserName(loginuaid,token);				
				String msg="<b>"+prjno+" : "+billno+"</b> invoice generated by  <b>"+assignby+"</b> for <b>"+clname+"</b>";
				ClientACT.addNotification(uuid, key, msg, pagename, "billing", "1", cuid, "1", "1", addeduser, token,clientpage, loginuaid,accesscode,"1","1");
			}
			
			}
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

}