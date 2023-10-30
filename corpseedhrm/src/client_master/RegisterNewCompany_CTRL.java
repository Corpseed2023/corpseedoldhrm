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
import admin.master.Usermaster_ACT;

@SuppressWarnings("serial")
public class RegisterNewCompany_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = true;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		
		String cregucid=Clientmaster_ACT.getetocode(token);
		String initial = Usermaster_ACT.getStartingCode(token,"imclientkey");
		if (cregucid==null) {
			cregucid=initial+"1";
		}
		else {
			String c=cregucid.substring(initial.length());
			
				int j=Integer.parseInt(c)+1;
				cregucid=initial+Integer.toString(j);
			}

		
try{
		String compname = request.getParameter("compname").trim();
		String industrytype = request.getParameter("industrytype").trim();
		int superUser=Integer.parseInt(request.getParameter("superUser").trim());
		String pan = request.getParameter("pan");
		if(pan!=null&&pan.length()>0)pan=pan.trim();
		String gstin =request.getParameter("gstin");
		if(gstin!=null&&gstin.length()>0)gstin=gstin.trim();
		String city = request.getParameter("city").trim();
		String state = request.getParameter("state").trim();		
		String country =request.getParameter("country").trim();		
		String address=request.getParameter("address").trim();
		String clientkey=request.getParameter("clientkey").trim();
		String compAge=request.getParameter("compAge");
		if(compAge!=null)compAge=compAge.trim();
		
		String stateCode=request.getParameter("stateCode");
		if(stateCode==null)stateCode="NA";
		else
			stateCode=stateCode.trim();
		
		String addeduser=(String)session.getAttribute("loginuID");
		//saving company detailsString 
		status=Clientmaster_ACT.saveCompanyDetail(cregucid,compname,address,city,pan,gstin,addeduser, token,industrytype,state,country,clientkey,compAge,stateCode,superUser);
		if(status)pw.write("pass");
		else pw.write("fail");
}catch(Exception e){
			log.info("Error in AssignTask_CTRL \n"+e);
		}	
	}

}
