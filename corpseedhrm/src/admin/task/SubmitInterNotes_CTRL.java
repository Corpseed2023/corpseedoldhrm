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
public class SubmitInterNotes_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");		
		String today=DateUtil.getCurrentDateIndianFormat1();
		String time=DateUtil.getCurrentTime();
		String uaid = (String) session.getAttribute("loginuaid");
		String userName=Usermaster_ACT.getLoginUserName(uaid, uavalidtokenno);
		
		boolean flag=false;
		try {			
			String salesKey=request.getParameter("salesKey");
			String boxContent=request.getParameter("boxContent");
							
			//add chat thread
			String taskKey=RandomStringUtils.random(40,true,true);				
			String subject="Internal Notes";
			
			//getting sales name,project no and invoice no
			String salesData[]=TaskMaster_ACT.getSalesData(salesKey,uavalidtokenno);
			
			//set notification task assigned to team leader	
			flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],subject,"NA","NA","NA","NA",uaid,userName,today+" "+time,"Notes Written",boxContent,loginuID,uavalidtokenno,"NA","NA","NA","NA","NA");
			
			
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}