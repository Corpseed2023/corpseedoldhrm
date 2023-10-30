package admin.enquiry;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;

@SuppressWarnings("serial")
public class AddEstimatePaymentCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			HttpSession session = request.getSession(); 
			
			String payoption = request.getParameter("payoption").trim();
			String pdate = request.getParameter("pdate").trim();
			String transid = request.getParameter("transid").trim();
			String transamt = request.getParameter("transamt").trim();
			String sref = request.getParameter("sref").trim();
			String enqid = request.getParameter("enqid").trim();
			String key =RandomStringUtils.random(40, true, true);
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");	
			String uarefid= (String)session.getAttribute("uarefid");

			boolean flag=Enquiry_ACT.addEstimatePaymentDetails(key,pdate,sref,payoption,transid,transamt,"Not Approved",addedby,"1",token);
			if(flag){
				//adding message estimate payment added
				String uname=Usermaster_ACT.getLoginedUserName(uarefid, token);
				String clientname=Enquiry_ACT.getSalesClientName(sref,token);
				String enqfstatus=Enquiry_ACT.getLastStatus(enqid,token);
				String remarks="Estimate Payment added by "+uname+" of client "+clientname;
				Enquiry_ACT.saveFollowUp(enqid, enqfstatus, pdate, remarks, addedby, "00-00-0000", token, uarefid, "0");
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}