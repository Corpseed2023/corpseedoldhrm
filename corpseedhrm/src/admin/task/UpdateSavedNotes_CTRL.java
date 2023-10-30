package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.master.Usermaster_ACT;

import commons.DateUtil;


@SuppressWarnings("serial")
public class UpdateSavedNotes_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		boolean flag=false;
			String notificationKey = request.getParameter("notificationKey").trim();			
			String notes = request.getParameter("notes").trim();	
			String contact = request.getParameter("contact").trim();
			String conName="NA";
			String conMobile="NA";
			String conEmail="NA";
			String x[]=contact.split("#");
			if(x.length>0) {
				conName=x[0];
				conMobile=x[1];
				conEmail=x[2];
			}

			
			String token= (String)session.getAttribute("uavalidtokenno");
			String userUid=(String)session.getAttribute("loginuaid");
			String addedby=(String)session.getAttribute("loginuID");

			
			
//				getting login user name
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				
				//getting today's date
				String today=DateUtil.getCurrentDateIndianFormat1();
				
				//getting current time
				String Time=DateUtil.getCurrentTime();
								
				//set notification task 
				flag=TaskMaster_ACT.updateTaskNotification(notificationKey,conName,conMobile,conEmail,userUid,userName,today+" "+Time,notes,addedby,token);
			
				
			if(flag){
				pw.write("pass");
			}else pw.write("fail");			
		
	}

}