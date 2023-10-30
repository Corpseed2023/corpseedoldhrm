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
public class SaveEstimateTaskNotes_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//System.out.println("running good..................");
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		String token=(String)session.getAttribute("uavalidtokenno");
		
			String estimateKey = request.getParameter("estrefid").trim();			
			String notes = request.getParameter("notes");	
			String contactKey = Enquiry_ACT.getEstimateContactKey(estimateKey, token);
			String userInChat=request.getParameter("userInChat");
			
			String type = request.getParameter("type");
			String userUid=(String)session.getAttribute("loginuaid");
			String addedby=(String)session.getAttribute("loginuID");
			
			String conName="NA";
			String conMobile="NA";
			String conEmail="NA";
			String email="NA";
			String uaid="NA";
						
			
			if(contactKey!=null) {
			String contact[][]=TaskMaster_ACT.getAllSalesContacts(contactKey, token);
				if(contact!=null&&contact.length>0) {
					conName=contact[0][0];
					conMobile=contact[0][2];
					conEmail=contact[0][1];
				}
			}else {
				String contact = request.getParameter("contact");
				String x[]=contact.split("#");
				conName=x[0];
				conMobile=x[1];
				conEmail=x[2];
			}
			
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			//getting current time
			String Time=DateUtil.getCurrentTime();
			
//			getting login user name
			String userName=Usermaster_ACT.getLoginUserName(userUid, token);
			String salesKey="NA";
			boolean isInvoiced=Enquiry_ACT.isEstimateInvoiced(estimateKey, token);
			String salesTaskKey=RandomStringUtils.random(40,true,true);
			if(isInvoiced) {
			
			salesKey=TaskMaster_ACT.getSalesKeyByEstimateKey(estimateKey, token);
			String salesData[]=TaskMaster_ACT.getSalesData(salesKey, token);
			
				
			if(type.equalsIgnoreCase("Team")) {				
				uaid=salesData[6];
				String sellerName=Usermaster_ACT.getLoginUserName(uaid, token);
				email=Usermaster_ACT.getUserEmail(uaid, token);
				//add chat thread
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Notes Written";		
					
				//set notification task 
				TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notes","notes.png",conName,conMobile,conEmail,userUid,userName,today+" "+Time,subject,notes,addedby,token,"NA","NA","NA","NA",salesTaskKey);
			
			//adding notification
			String nKey=RandomStringUtils.random(40,true,true);
			String message="You have new note on unbill : "+salesData[2]+" by "+userName+" for "+salesData[0]+"";
//			System.out.println(uaid+"  "+userUid);
			if(!uaid.equalsIgnoreCase("NA")&&!userUid.equalsIgnoreCase(uaid))
			TaskMaster_ACT.addNotification(nKey,today,uaid,"2","manage-sales.html?uuid="+salesKey+"",message,token,userUid,"fas fa-tasks");
			
			if(userInChat!=null&&userInChat.length()>0) {
				//add notification
				
				String message1="You have new note on unbill : "+salesData[2]+" by "+userName+" for "+salesData[0]+"";
//				System.out.println(uaid+"  "+userUid);
				String x[]=userInChat.split(",");				
				for (String uaid1 : x) {
					String nKey1=RandomStringUtils.random(40,true,true);
					TaskMaster_ACT.addNotification(nKey1,today,uaid1,"2","manage-sales.html?uuid="+salesKey+"",message1,token,userUid,"fas fa-tasks");
				
					String user[]=Usermaster_ACT.findUserByUaid(Integer.parseInt(uaid1), token);
					
					String messageSender="<table border=\"0\" style=\"margin:0 auto; min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\r\n"
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
							+ "            Hi "+user[0]+",</td></tr>"
							+ "             <tr>"
							+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
							+ "                     <p>You have received an internal note from "+userName+" for "+salesData[0]+" is as follow :</p>\r\n"
							+ "                     <p>"+notes+"</p><p>Please do the needful.</p>\r\n"
							+ "                    </td></tr>  \r\n"
							+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
							+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
							+ "    </td></tr> \r\n"
							+ "    </tbody></table>";				
					if(!user[1].equalsIgnoreCase("NA"))
					Enquiry_ACT.saveEmail(user[1],"empty","Note From "+userName+" On "+salesData[0]+"("+salesData[2]+")", messageSender,2,token);
				}
					
			}
			
			
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
					+ "            Hi "+sellerName+",</td></tr>"
					+ "             <tr>"
					+ "                    <td style=\"padding: 10px 0;color: #353637;\"> \r\n"
					+ "                     <p>You have received an internal note from "+userName+" for "+salesData[0]+" is as follow :</p>\r\n"
					+ "                     <p>"+notes+"</p><p>Please do the needful.</p>\r\n"
					+ "                    </td></tr>  \r\n"
					+ "             <tr><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\r\n"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\r\n"
					+ "    </td></tr> \r\n"
					+ "    </tbody></table>";				
			if(!email.equalsIgnoreCase("NA")&&!userUid.equalsIgnoreCase(uaid))
			Enquiry_ACT.saveEmail(email,"empty","Note From "+userName+" On "+salesData[0]+"("+salesData[2]+")", message1,2,token);
			
				}	
			}else if(type.equalsIgnoreCase("Team")) {
				String estNKey=RandomStringUtils.random(40,true,true);
				Enquiry_ACT.saveEstimateNotes(estNKey,estimateKey,notes,userInChat,userUid,addedby,token);								
			}
			
			TaskMaster_ACT.saveSalesNotification(salesTaskKey,type,uaid,userName,today+" "+Time,token,salesKey,notes,estimateKey);
			
			String data="<div class=\"contentInnerBox box_shadow1 relative_box mb10 mtop10\">\n"
					+ "	<div class=\"sms_head note_box\">\n"
					+ "	<div class=\"note_box_inner\"> \n"
					+ "	"+notes+"\n"
					+ "	</div>\n"
					+ "	<span class=\"icon_box1 text-center\" title=\""+userName+"\">"+userName.substring(0, 2)+"</span>\n"
					+ "	</div>	\n"
					+ "	<div class=\"sms_title\"> \n"
					+ "	<label class=\"pad-rt10\"><img src=\"/corpseedhrm/staticresources/images/long_arrow_down.png\" alt=\"\">&nbsp; Notes Written</label>  \n"
					+ "	<span class=\"gray_txt bdr_bt pad-rt10\">Just Now</span>\n"
					+ "	</div>\n"
					+ "	</div>";
				
				pw.write(data);	
					
	}

}