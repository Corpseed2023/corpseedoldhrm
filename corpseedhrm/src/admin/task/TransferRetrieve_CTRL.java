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
import client_master.Clientmaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;
import hcustbackend.ClientACT;

public class TransferRetrieve_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			boolean flag=false;
			PrintWriter pw=response.getWriter();
			HttpSession session=request.getSession();
			
			String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
			String uaid = (String) session.getAttribute("loginuaid");
			String userName=Usermaster_ACT.getLoginUserName(uaid, uavalidtokenno);
			String loginuID = (String) session.getAttribute("loginuID");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String time=DateUtil.getCurrentTime();
			
			String taskKey=request.getParameter("taskKey");
			if(taskKey!=null)taskKey=taskKey.trim();
			
			String status=request.getParameter("status");
			if(status!=null)status=status.trim();
			
			String salesKey=request.getParameter("salesKey");
			if(salesKey!=null)salesKey=taskKey.trim();
			
			String clientrefId=request.getParameter("clientKey");
			if(clientrefId!=null)clientrefId=clientrefId.trim();
			
			String taskName=request.getParameter("taskName");
			if(taskName!=null)taskName=taskName.trim();
			
			if(status!=null) {				
				int status1=1;
				if(status.equalsIgnoreCase("1"))status1=2;
				//updating task transfer retrieve status
				flag=TaskMaster_ACT.updateTransferRetrieve(taskKey,status1);
				if(flag) {
					
					String clientUid=ClientACT.getClientIdByKey(clientrefId, uavalidtokenno);
					String clientName=Clientmaster_ACT.getClientName(clientUid, uavalidtokenno);
					
					//getting sales name,project no and invoice no
					String salesData[]=TaskMaster_ACT.getSalesData(salesKey,uavalidtokenno);
					
					//getting primary contact data
					String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], uavalidtokenno);
					
					//add chat thread
					String taskKey1=RandomStringUtils.random(40,true,true);				
					String subject="Notification";
					String content="";
					String message="";
					if(status1==1) {
					 content="<span style=\"color: #4ac4f3;font-weight: 600;\">"+taskName+"</span> has been transfered to client by "+userName+" on "+today+" "+time+" ticket is on-hold for next 15 days.";
					//sending email to client of successfully estimate created			
						message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>ORDER UPDATE</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+clientName+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p>As per our dicussion we are tranferring the '"+taskName+"' to you. Please update our team '"+taskName+"' once it's done.\n"
								+ "                      </p>\n"					
								+ "                    </td></tr>  \n"
								+ "                         <tr>\n"
								+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
								+ "                                  <h2 style=\"text-align: center;\">NOTES</h2>\n"
								+ "                                 <p style=\"text-align: center;\">System will mark the '"+taskName+"' to be completed after 15 days from assiging date.\n"
								+ "                                  </p>\n"								
								+ "                                </td></tr>  \n"
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
					
					}else if(status1==2) {				
						content="<span style=\"color: #4ac4f3;font-weight: 600;\">"+taskName+"</span> has been transfered back to "+userName+" on "+today+" "+time+".";
					
						message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>ORDER UPDATE</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+clientName+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p>Thank you for choosing us. As per our discussion we will be tranferring back the '"+taskName+"' to '"+userName+"'.\n"
								+ "                      </p>\n"					
								+ "                    </td></tr>  \n"
								+ "                         <tr>\n"
								+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
								+ "                                  <h2 style=\"text-align: center;\">NOTES</h2>\n"
								+ "                                 <p style=\"text-align: center;\">System will mark the '"+taskName+"' to be completed after 15 days from assiging date.\n"
								+ "                                  </p>\n"								
								+ "                                </td></tr>  \n"
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
					
					}
					//set notification task assigned to team leader	
					flag=TaskMaster_ACT.setTaskNotification(taskKey1,salesKey,salesData[0],salesData[1],salesData[2],subject,"bell.png",contactData[0],contactData[1],contactData[2],uaid,userName,today+" "+time,subject,content,loginuID,uavalidtokenno,clientUid,"Admin",clientName,"NA","NA");
					String contactEmail=contactData[2];
					if(contactEmail!=null&&!contactEmail.equalsIgnoreCase("NA")&&contactEmail.length()>0)
						Enquiry_ACT.saveEmail(contactEmail,"empty","Milestone Update", message,2,uavalidtokenno);
									
					
				pw.write("pass");
				}else pw.write("fail");
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
