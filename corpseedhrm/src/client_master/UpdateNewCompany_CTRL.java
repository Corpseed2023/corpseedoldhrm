package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.enquiry.Enquiry_ACT;
import admin.task.TaskMaster_ACT;

@SuppressWarnings("serial")
public class UpdateNewCompany_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = true;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		
				
try{
		String industrytype = request.getParameter("industrytype").trim();
		int superUserUaid=Integer.parseInt(request.getParameter("superUser").trim());
		String pan = request.getParameter("pan").trim();
		String gstin = request.getParameter("gstin").trim();
		String city = request.getParameter("city").trim();
		String state = request.getParameter("state").trim();		
		String country =request.getParameter("country").trim();		
		String address=request.getParameter("address").trim();
		String companykey=request.getParameter("companykey").trim();
		String companyAge=request.getParameter("companyAge");
		String stateCode=request.getParameter("stateCode").trim();
		String companyName=request.getParameter("companyName");
		if(companyName==null) {		
//		System.out.println(industrytype+"/"+pan+"/"+gstin+"/"+city+"/"+state+"/"+country+"/"+address+"/"+companykey+"/"+token);
		//saving company detailsString 
		status=Clientmaster_ACT.updateCompanyDetail(industrytype,pan,gstin,city,state,country,address,companykey,token,companyAge,stateCode,superUserUaid);
		}else {
			status=Clientmaster_ACT.updateCompanyDetail(industrytype,pan,gstin,city,state,country,address,companykey,token,companyAge,stateCode,companyName,superUserUaid);
			//updating estimate company name
			Enquiry_ACT.updateEstimateCompany(companykey,companyName,token);
			//updating managesales company name
			TaskMaster_ACT.updateSalesCompany(companykey,companyName,token);
			//updating contact company name
			TaskMaster_ACT.updateContactCompany(companykey,companyName,token);	
			//updating billing company name
			TaskMaster_ACT.updateBillingCompany(companykey,companyName,token);
			//updating user_account company name
			String clientNumber=Clientmaster_ACT.getClientNumberByKey(companykey, token);
			TaskMaster_ACT.updateUserCompany(clientNumber,companyName,token);
		}
		if(status)pw.write("pass");
		else pw.write("fail");
		
	}catch(Exception e){e.printStackTrace();
	log.info("Error in UpdateNewCompany_CTRL \n"+e);
		}	
	}

}
