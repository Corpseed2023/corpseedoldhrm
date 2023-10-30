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
public class UpdateSalesContactDetails_CTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		boolean status = false;
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String token= (String)session.getAttribute("uavalidtokenno");
		
try{
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
		
		String id =request.getParameter("stbid");
		if(id!=null)id=id.trim();
		
		String salesKey =request.getParameter("salesKey");
		if(salesKey!=null)salesKey=salesKey.trim();
		
		String userUid=(String)session.getAttribute("loginuaid");
		String addedby=(String)session.getAttribute("loginuID");
		String today=DateUtil.getCurrentDateIndianFormat1();		
		
		//updating contact details
		status=Clientmaster_ACT.updateSalesContactDetail(id,firstname,lastname,email,email2,workphone,mobile,token);
			if(status) {
				if(salesKey!=null&&!salesKey.equalsIgnoreCase("NA")) {
				//adding notification
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				//getting current time
				String Time=DateUtil.getCurrentTime();
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				String taskKey=RandomStringUtils.random(40,true,true);	
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				String content="Contact <span style='color: #4ac4f3;font-weight: 600;'>'"+firstname+" "+lastname+"'</span> updated by&nbsp;<span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
				String subject="Contact Updated";
				//set notification task assigned to team leader
				TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notification","bell.png",contactData[0],contactData[1],contactData[2],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA","NA","NA");		
				}				
				
				pw.write("pass");
			}
			else pw.write("fail");
		}catch(Exception e){
			log.info("Error in UpdateContactDetails_CTRL \n"+e);
		}	
	}

}
