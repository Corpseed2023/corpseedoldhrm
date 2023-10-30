package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;

import commons.DateUtil;


@SuppressWarnings("serial")
public class SaveTaskNotes111_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//System.out.println("running good..................");
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		boolean flag=false;
			String salesKey = request.getParameter("salesrefid").trim();			
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
				
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				
				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Notes Written";
				
				//set notification task 
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notes","notes.png",conName,conMobile,conEmail,userUid,userName,today+" "+Time,subject,notes,addedby,token,"NA","NA","NA","NA","NA");
			
				
			if(flag){
				pw.write("pass");
			}else pw.write("fail");			
		
	}

}