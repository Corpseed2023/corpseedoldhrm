package client_master;

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
import admin.enquiry.Enquiry_ACT;
import commons.EmailVerifier;

@SuppressWarnings("serial")
public class RegisterNewContact_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = true;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		String addedby = (String)session.getAttribute("loginuID");
try{
		String compname = request.getParameter("compname");
		if(compname==null||compname.length()<=0)compname="NA";
		
		String firstname = request.getParameter("firstname");
		if(firstname==null||firstname.length()<=0)firstname="NA";
		
		String lastname = request.getParameter("lastname");
		if(lastname==null||lastname.length()<=0)lastname="NA";
		
		String email =request.getParameter("email");
		if(email==null||email.length()<=0)email="NA";
		
		String email2 = request.getParameter("email2");
		if(email2==null||email2.length()<=0)email2="NA";
		
		String workphone = request.getParameter("workphone");
		if(workphone==null||workphone.length()<=0)workphone="NA";
		
		String mobile =request.getParameter("mobile");	
		if(mobile==null||mobile.length()<=0)mobile="NA";
		
		String city=request.getParameter("city");
		if(city==null||city.length()<=0)city="NA";
		
		String state = request.getParameter("state");
		if(state==null||state.length()<=0)state="NA";
		
		String stateCode =request.getParameter("stateCode");
		if(stateCode==null||stateCode.length()<=0)stateCode="NA";
		
		String country = request.getParameter("country");
		if(country==null||country.length()<=0)country="NA";
		
		String pan = request.getParameter("pan");
		if(pan==null||pan.length()<=0)pan="NA";
		
		String address =request.getParameter("address");
		if(address==null||address.length()<=0)address="NA";
		
		String companyaddress=request.getParameter("companyaddress");
		if(companyaddress==null||companyaddress.length()<=0)companyaddress="NA";
		
		String addresstype = request.getParameter("addresstype");
		if(addresstype==null||addresstype.length()<=0)addresstype="NA";
		
		String key =request.getParameter("key");
		if(key==null||key.length()<=0)key="NA";
		
		String CompanyRefId = request.getParameter("CompanyRefId");
		if(CompanyRefId==null||CompanyRefId.length()<=0)CompanyRefId="NA";
		String suser_id=request.getParameter("super_user_id");
		if(suser_id==null||suser_id.length()<=0) {
			suser_id=Clientmaster_ACT.findClientSuperUserByKey(CompanyRefId, token)+"";
		}		
		int super_user_id=Integer.parseInt(suser_id);
		
		String salesid =request.getParameter("salesid");
		if(salesid==null||salesid.length()<=0||salesid.equalsIgnoreCase("NA"))salesid="NA";
		else salesid=salesid.trim();
		
		String contactid =request.getParameter("contid");
		if(contactid==null||contactid.length()<=0||contactid.equalsIgnoreCase("NA"))contactid="NA";
		else contactid=contactid.trim();
		
		String addeduser=(String)session.getAttribute("loginuID");
		
		if(addresstype.equalsIgnoreCase("Company")){
			address=companyaddress;
		}
		
		
		//checking entered email is valid or not
		boolean addressValid = EmailVerifier.isAddressValid(email);
		if(email2!=null&&!email2.equalsIgnoreCase("NA")) {
			addressValid = EmailVerifier.isAddressValid(email2);
		}
		if(addressValid) {
			boolean isprimary=Clientmaster_ACT.isPrimaryContact(CompanyRefId,token);
			String primaryStatus="1";
			if(isprimary)primaryStatus="2";
			//saving company detailsString 
			status=Clientmaster_ACT.saveContactDetail(CompanyRefId,key,compname,firstname,lastname,email,email2,workphone,mobile,city,state,addresstype,address,addeduser,token,primaryStatus,country,pan,stateCode,super_user_id);
			
			if(!isprimary)
				Clientmaster_ACT.updateClientPersonalData(CompanyRefId, firstname, lastname, email, workphone, city, state, address, token);
			
			if(!salesid.equalsIgnoreCase("NA")&&!contactid.equalsIgnoreCase("NA")) {
				
				//saving contact data in virtual contact table				
				status=Enquiry_ACT.isContactExist(mobile,salesid,token,addedby,email);
				if(!status){
					//adding new contact
					String vkey =RandomStringUtils.random(40, true, true);
					status=Enquiry_ACT.addSalesContactToVirtual(vkey,contactid,firstname+" "+lastname,email,workphone,mobile,salesid,token,addeduser,key);
	//				System.out.println("add executed....");
				}else{
					//updating added contact details
					status=Enquiry_ACT.updateSalesContactToVirtual(contactid,firstname+" "+lastname,email,workphone,mobile,salesid,token,addedby);
	//				System.out.println("updating contact....");
				}
			}
			if(status)pw.write("pass");
			else pw.write("fail");
		}else {
			pw.write("invalid");
		}
		
}catch(Exception e){
	e.printStackTrace();
			log.info("Error in RegisterNewContact_CTRL \n"+e);
		}	
	}

}
