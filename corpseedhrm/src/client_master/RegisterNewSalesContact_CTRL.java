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
import commons.EmailVerifier;

@SuppressWarnings("serial")
public class RegisterNewSalesContact_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		boolean status = true;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		
try{
		String compname = request.getParameter("compname");
		if(compname!=null)compname=compname.trim();
		
		String firstname = request.getParameter("firstname");
		if(firstname!=null)firstname=firstname.trim();
		
		String lastname = request.getParameter("lastname");
		if(lastname!=null)lastname=lastname.trim();
		
		String email =request.getParameter("email");
		if(email!=null)email=email.trim();
				
		String email2 = request.getParameter("email2");
		if(email2!=null)email2=email2.trim();
				
		String workphone = request.getParameter("workphone");	
		if(workphone!=null)workphone=workphone.trim();
		
		String mobile =request.getParameter("mobile");
		if(mobile!=null)mobile=mobile.trim();
		
		String city=request.getParameter("city");
		if(city!=null)city=city.trim();
		
		String country=request.getParameter("country");
		if(country!=null)country=country.trim();
		
		String pan=request.getParameter("pan");
		if(pan!=null)pan=pan.trim();
		
		String state = request.getParameter("state");
		if(state!=null)state=state.trim();
		
		String address =request.getParameter("address");
		if(address!=null)address=address.trim();
		
		String companyaddress=request.getParameter("companyaddress");	
		if(companyaddress!=null)companyaddress=companyaddress.trim();
		
		String addresstype = request.getParameter("addresstype");
		if(addresstype!=null)addresstype=addresstype.trim();
		
		String key =request.getParameter("key");
		if(key!=null)key=key.trim();
		
		String salesKey =request.getParameter("salesKey");
		if(salesKey!=null)salesKey=salesKey.trim();
		
		String contactkey = request.getParameter("contactkey");
		if(contactkey!=null)contactkey=contactkey.trim();
		
		String CompanyRefId = request.getParameter("CompanyRefId");
		if(CompanyRefId!=null)CompanyRefId=CompanyRefId.trim();
		
		String addeduser=(String)session.getAttribute("loginuID");
		String userUid=(String)session.getAttribute("loginuaid");
		String addedby=(String)session.getAttribute("loginuID");
		String today=DateUtil.getCurrentDateIndianFormat1();
		
		if(addresstype.equalsIgnoreCase("Company")){
			address=companyaddress;
		}
		//checking entered email is valid or not
		boolean addressValid = EmailVerifier.isAddressValid(email);
		if(email2!=null&&!email2.equalsIgnoreCase("NA")) {
			addressValid = EmailVerifier.isAddressValid(email2);
		}
		if(addressValid) {
			int super_user_id=Clientmaster_ACT.findClientSuperUserByKey(CompanyRefId, token);
			//saving company detailsString 
			status=Clientmaster_ACT.saveContactDetail(CompanyRefId,key,compname,firstname,lastname,email,email2,workphone,mobile,city,state,addresstype,address,addeduser,token,"2",country,pan,"NA",super_user_id);
		
		if(status){
			status=Clientmaster_ACT.addContactToSalesBox(contactkey,firstname+" "+lastname,email,email2,workphone,mobile,token,addeduser,key);
			//adding notification
			//getting sales name,project no and invoice no
			String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
			//getting current time
			String Time=DateUtil.getCurrentTime();
			//getting primary contact data
			String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
			String taskKey=RandomStringUtils.random(40,true,true);	
			String userName=Usermaster_ACT.getLoginUserName(userUid, token);
			String content="New Contact <span style='color: #4ac4f3;font-weight: 600;'>'"+firstname+" "+lastname+"'</span> added by&nbsp;<span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
			String subject="Contact Added";
			//set notification task assigned to team leader	
			TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA","NA","NA");
		}
		if(status)pw.write("pass");
		else pw.write("fail");		
		}else {
			pw.write("invalid");
		}
		
		
		}catch(Exception e){
			log.info("Error in RegisterNewContact_CTRL \n"+e);
		}	
	}

}
