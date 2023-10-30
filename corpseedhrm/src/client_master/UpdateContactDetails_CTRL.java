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
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class UpdateContactDetails_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

//		System.out.println("class called.......");
		
		boolean status = false;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		String loginuaid = (String)session.getAttribute("loginuaid");
		String addeduser=(String)session.getAttribute("loginuID");
		String today=DateUtil.getCurrentDateIndianFormat1();
try{
		String firstname = request.getParameter("firstname").trim();
		String lastname = request.getParameter("lastname").trim();
		String email =request.getParameter("email").trim();
		String email2 = request.getParameter("email2").trim();
		String workphone = request.getParameter("workphone").trim();		
		String mobile =request.getParameter("mobile").trim();
		
		String city=request.getParameter("city");
		if(city!=null)city=city.trim();
		
		String state = request.getParameter("state");
		if(state!=null)state=state.trim();
		
		String stateCode = request.getParameter("stateCode");
		if(stateCode!=null)stateCode=stateCode.trim();
		
//		System.out.println("state code=="+stateCode);
		
		String country = request.getParameter("country");
		if(country!=null)country=country.trim();
		
		String pan = request.getParameter("pan");
		if(pan!=null)pan=pan.trim();
		
		String address =request.getParameter("address").trim();		
		String companyaddress=request.getParameter("companyaddress").trim();	
		String addresstype = request.getParameter("addresstype").trim();
		String contkey =request.getParameter("contkey").trim();
		
		String salesid =request.getParameter("salesid");
		if(salesid==null||salesid.length()<=0||salesid.equalsIgnoreCase("NA"))salesid="NA";
		
		String contactid =request.getParameter("contid");
		if(contactid==null||contactid.length()<=0||contactid.equalsIgnoreCase("NA"))contactid="NA";
		
		if(addresstype.equalsIgnoreCase("Company")){
			address=companyaddress;
			city="NA";
			state="NA";
		}
				
//		String oldWorkPhone=Clientmaster_ACT.getContactWorkPhone(contkey,token);
		
		//updating contact details
		status=Clientmaster_ACT.updateContactDetail(contkey,firstname,lastname,email,email2,workphone,mobile,city,state,addresstype,address,token,country,pan,stateCode);
//		System.out.println("updated==="+status);
		if(status) {
			String clientKey=Enquiry_ACT.getClientKey(contkey,token);
			    
			String clientId=Enquiry_ACT.getClientIdByRefid(clientKey, token);
			 //adding notification
			String nKey=RandomStringUtils.random(40,true,true);
			String message="Your contact name : <span class='text-info'>"+firstname+" "+lastname+"</span> is updated.";
			TaskMaster_ACT.addNotification(nKey,today,clientId,"1","my_profile.html",message,token,loginuaid,"far fa-address-card");
						
			String userNKey=RandomStringUtils.random(40,true,true);
			String userMessage="Contact name : <span class='text-info'>"+firstname+" "+lastname+"</span> is updated.";
			TaskMaster_ACT.addNotification(userNKey,today,loginuaid,"2","manage-estimate.html",userMessage,token,loginuaid,"far fa-address-card");
//			String clientNumberByKey=Clientmaster_ACT.getClientNumberByKey(clientKey, token);
			
//			String ualoginId=Usermaster_ACT.getClientUserName(clientNumberByKey, token); 
//			
//			if(oldWorkPhone.equalsIgnoreCase(ualoginId)&&!workphone.equalsIgnoreCase(ualoginId)) {
//				boolean ustatus=Usermaster_ACT.updateClientUsername(clientNumberByKey,mobile,token);
//				if(ustatus) {
//					String message1="<p>Hi "+firstname+",</p>"
//							+"<p>Your username has been updated</p>"
//							+"<p>Username : "+mobile+"</p><p>"
//									+ "You may login to your account by visiting <a href='https://crm.corpseed.com'>https://crm.corpseed.com</a></p><p>"
//									+ "Please remember that your username and password is case sensitive.To Change your password, Login and use Profile->My Profile and click on update Password.</p>";				
//					Enquiry_ACT.saveEmail(email,"empty","Account Information | Corpseed", message1, 2, token);	
//				}
//			}
			int contactId=TaskMaster_ACT.findContactIdByKey(contkey,token);
//			System.out.println("contactId==="+contactId);
			if(contactId>0)
				Usermaster_ACT.updateUserMobileAndEmail(email,workphone,contactId,token,firstname+" "+lastname);
			
		   if(!salesid.equalsIgnoreCase("NA")&&!contactid.equalsIgnoreCase("NA")) {					
				//saving contact data in virtual contact table				
				status=Enquiry_ACT.isContactExist(mobile,salesid,token,addeduser,email);
				if(!status){
					String vkey =RandomStringUtils.random(40, true, true);
					//adding new contact
					status=Enquiry_ACT.addSalesContactToVirtual(vkey,contactid,firstname+" "+lastname,email,workphone,mobile,salesid,token,addeduser,contkey);
	//				System.out.println("add executed....");
				}else{
					//updating added contact details
					status=Enquiry_ACT.updateSalesContactToVirtual(contactid,firstname+" "+lastname,email,workphone,mobile,salesid,token,addeduser);
	//				System.out.println("updating contact....");
				}
			}
			   
			pw.write("pass");	
		}else pw.write("fail");
		
}catch(Exception e){e.printStackTrace();
			log.info("Error in UpdateContactDetails_CTRL \n"+e);
		}	
	}

}
