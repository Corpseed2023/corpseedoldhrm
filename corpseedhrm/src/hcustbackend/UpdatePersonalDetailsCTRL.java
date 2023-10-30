package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class UpdatePersonalDetailsCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		   		
		try {
			HttpSession session=request.getSession();
			String loginuaid = (String) session.getAttribute("loginuaid");
						
			String firstName=request.getParameter("firstName");
			if(firstName!=null)firstName=firstName.trim();
			
			String lastName =request.getParameter("lastName");
			if(lastName!=null)lastName=lastName.trim();
			
			String email_id1 =request.getParameter("email_id1");
			if(email_id1!=null)email_id1=email_id1.trim();
			
			String email_id2 =request.getParameter("email_id2");
			if(email_id2!=null)email_id2=email_id2.trim();
			
			String mobile1=request.getParameter("mobile1");
			if(mobile1!=null)mobile1=mobile1.trim();
			
			String mobile2=request.getParameter("mobile2");
			if(mobile2!=null)mobile2=mobile2.trim();
			
			String pan=request.getParameter("pan");
			if(pan!=null)pan=pan.trim();
			
			String country=request.getParameter("country");
			if(country!=null)country=country.trim();
			
			String city=request.getParameter("city");
			if(city!=null)city=city.trim();
			
			String state =request.getParameter("state");
			if(state!=null)state=state.trim();
			
			String stateCode =request.getParameter("stateCode");
			if(stateCode!=null)stateCode=stateCode.trim();
			
			String address =request.getParameter("address");
			if(address!=null)address=address.trim();			
			
			String token=(String)session.getAttribute("uavalidtokenno");		 	
			PrintWriter pw=response.getWriter();
			
//			System.out.println("mobile==="+mobile1+"#"+mobile2);
						
			int contactId=Usermaster_ACT.findContactIdByUaid(loginuaid, token);
						
			boolean flag=Clientmaster_ACT.updateContactDetails1(contactId, firstName, lastName, email_id1, email_id2, mobile1,
					mobile2, pan, country, city, state, stateCode, address, token,"Personal");
			if(flag) {
				//update sales contact
				String clientKey=Clientmaster_ACT.findContactKeyById(contactId,token);
				if(clientKey!=null&&!clientKey.equalsIgnoreCase("NA"))
					Clientmaster_ACT.updateSalesContactDetailByKey(clientKey, firstName, lastName, email_id1, email_id2,mobile1,mobile2,token);
				if(contactId>0)
					Usermaster_ACT.updateUserMobileAndEmail(email_id1,mobile1,contactId,token,firstName+" "+lastName);
				
				pw.write("pass");
			}else
				pw.write("fail");
//			if(flag) {
//				String ualoginId=Usermaster_ACT.findUsernameByUaid(loginuaid,token);
//				if(!mobile1.equalsIgnoreCase(ualoginId)&&!mobile2.equalsIgnoreCase(ualoginId)) {
//					boolean ustatus=Usermaster_ACT.updateClientUsername(loginuaid,mobile1,token);
//					if(ustatus) {
//						//update salesContact
//						
//						//update user ualoginid,mobile and email
//						String message="<p>Hi "+firstName+",</p>"
//								+"<p>Your username has been updated</p>"
//								+"<p>Username : "+mobile1+"</p><p>"
//										+ "You may login to your account by visiting <a href='https://crm.corpseed.com'>https://crm.corpseed.com</a></p><p>"
//										+ "Please remember that your username and password is case sensitive.To Change your password, Login and use Profile->My Profile and click on update Password.</p>";				
//						Enquiry_ACT.saveEmail(email_id1,"empty","Account Information | Corpseed", message, 2, token);	
//					}
//				}		
//				
//				pw.write("pass");
//				
//			}else pw.write("fail");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
