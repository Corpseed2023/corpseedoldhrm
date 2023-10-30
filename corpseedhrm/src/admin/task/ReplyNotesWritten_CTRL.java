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


@SuppressWarnings("serial")
public class ReplyNotesWritten_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//System.out.println("running good..................");
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		String token=(String)session.getAttribute("uavalidtokenno");
		
			String salesKey = request.getParameter("salesKey").trim();			
			String notes = request.getParameter("comment");	
			String contactKey = request.getParameter("contactKey").trim();	
			String uaid = request.getParameter("uaid").trim();	
			
			String userUid=(String)session.getAttribute("loginuaid");
			String addedby=(String)session.getAttribute("loginuID");
			String conName="NA";
			String conMobile="NA";
			String conEmail="NA";
			boolean flag=false;
			
			String contact[][]=TaskMaster_ACT.getAllSalesContacts(contactKey, token);
			if(contact!=null&&contact.length>0) {
				conName=contact[0][0];
				conMobile=contact[0][2];
				conEmail=contact[0][1];
			}
			
//				getting login user name
				String userName=Usermaster_ACT.getLoginUserName(userUid, token);
				
				//getting today's date
				String today=DateUtil.getCurrentDateIndianFormat1();
				
				//getting current time
				String Time=DateUtil.getCurrentTime();
				
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				String salesTaskKey=RandomStringUtils.random(40,true,true);	
				
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Notes Written";		
					
				//set notification task 
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notes","notes.png",conName,conMobile,conEmail,userUid,userName,today+" "+Time,subject,notes,addedby,token,"NA","NA","NA","NA",salesTaskKey);
				
				String estimateKey=TaskMaster_ACT.getEstimateKey(salesKey, token);
				flag=TaskMaster_ACT.saveSalesNotification(salesTaskKey,"Team",uaid,userName,today+" "+Time,token,salesKey,notes,estimateKey);
				
				String receiverName=Usermaster_ACT.getLoginUserName(uaid, token);
				String email=Usermaster_ACT.getUserEmail(uaid, token);
				
				
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String message="You have new note on unbill : "+salesData[2]+" by "+userName+" for "+salesData[0]+"";
				TaskMaster_ACT.addNotification(nKey,today,uaid,"2","manage-sales.html?uuid="+salesKey+"",message,token,userUid,"fas fa-tasks");
				
				
				String message1="<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
						+ "        <tbody><tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\r\n"
						+ "                <a href=\"#\" target=\"_blank\">\r\n"
						+ "                <img src=\"https://www.corpseed.com/assets/img/logo.png\"></a>\r\n"
						+ "            </td></tr>\r\n"
						+ "            <tr>\r\n"
						+ "              <td style=\"text-align: center;\">\r\n"
						+ "                <h1 style=\"font-size: 28px;line-height: 38px;\">Note From "+userName+" On "+salesData[0]+"("+salesData[2]+")</h1>\r\n"
						+ "              </td></tr>\r\n"
						+ "        <tr>\r\n"
						+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\r\n"
						+ "            Hi "+receiverName+",</td></tr>"
						+ "             <tr>"
						+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
						+ "                     <p>You have received an internal note from "+userName+" for "+salesData[0]+" is as follow :</p>\r\n"
						+ "                     <p>"+notes+"</p><p>Please do the needful.</p>\r\n"
						+ "                    </td></tr>  \r\n"
						+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
						+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
						+ "    </td></tr> \r\n"
						+ "    </tbody></table>";				
				Enquiry_ACT.saveEmail(email,"empty","Note From "+userName+" On "+salesData[0]+"("+salesData[2]+")", message1,2,token);
				
				
				
				if(flag)pw.write("pass");
				else pw.write("fail");	
					
	}

}