package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class SetSalesReminder_CTRL extends HttpServlet {	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");
		String uaid = (String) session.getAttribute("loginuaid");
		
			
		String salesrefid = request.getParameter("salesrefid").trim();	
		String content = request.getParameter("content").trim();	
		String Time = request.getParameter("Time").trim();	
		String Date = request.getParameter("Date").trim();	
		String assignTaskKey=request.getParameter("taskKey");
		
		
		String reminderKey=RandomStringUtils.random(40,true,true);
		
		boolean flag=TaskMaster_ACT.setSalesReminder(reminderKey,salesrefid,uaid,content,Date,Time,loginuID,uavalidtokenno,assignTaskKey);		
		if(flag) {
			
			String today=DateUtil.getCurrentDateIndianFormat1();
			//getting current time
			String Time1=DateUtil.getCurrentTime();
			//getting sales name,project no and invoice no
			String salesData[]=TaskMaster_ACT.getSalesData(salesrefid,uavalidtokenno);
			//getting primary contact data
			String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], uavalidtokenno);
			String taskKey=RandomStringUtils.random(40,true,true);				
			String subject="Reminder added";
			String userName=Usermaster_ACT.getLoginUserName(uaid, uavalidtokenno);
			String content1=userName+" has added reminder on "+Date+" - "+Time+" for <span style='color:#337ab7'> "+content+".</span>";
			//set notification task assigned to team leader	
			flag=TaskMaster_ACT.setTaskNotification(taskKey,salesrefid,salesData[0],salesData[1],salesData[2],"Reminder","reminder.png",contactData[0],contactData[1],contactData[2],uaid,userName,today+" "+Time1,subject,content1,loginuID,uavalidtokenno,"NA","NA","NA","NA","NA");
			
			
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}