package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class SendLoginCredential_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			HttpSession session = request.getSession();
			String token= (String)session.getAttribute("uavalidtokenno");
			String userUid=(String)session.getAttribute("loginuaid");
			String addedby=(String)session.getAttribute("loginuID");
			String today=DateUtil.getCurrentDateIndianFormat1();
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String domain=properties.getProperty("domain");
			
			PrintWriter out=response.getWriter();
			boolean result=false;
			String salesKey=request.getParameter("salesKey");
			if(salesKey!=null)salesKey=salesKey.trim();
			String[] parameterValues = request.getParameterValues("formData[]");
			if(parameterValues!=null&&parameterValues.length>0)
			for (String data : parameterValues) {							
				String uaid=data.substring(0,data.indexOf("#")).trim();
				String email=data.substring(data.indexOf("#")+1).trim();
				
//				System.out.println("uaid===="+uaid+"\nemail="+email);
				if(uaid!=null&&uaid.length()>0&&!uaid.equalsIgnoreCase("NA")
						&&email!=null&&email.length()>0&&!email.equalsIgnoreCase("NA")) {
//					System.out.println("inside------"+email+"#"+uaid);
				String user[]=Usermaster_ACT.findUserDataByUaid(uaid, token);
				
				if(user.length>0&&user[0]!=null&&user[1]!=null&&user[2]!=null&&user[3]!=null) {					
						
						String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>Login Credential</h1>"					
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+user[0]+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p> Thank you for choosing Corpseed for your business. Your order has been received. \n"
								+ "                      </p><p>Use link to <a href=\""+domain+"client_orders.html\">track your order</a>.</p>\n"					
								+ "                    <p style=\"line-height: 4rem;\">Your login credentials for the order :-<br>Username :- "+user[2]+"<br>Password :- "+user[3]+"</p>"
								+ "						<p><b>Note:-</b> Please don\"t share these credentials with anyone.</p></td></tr>  \n"
							
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <p>Address:Corpseed, A-43, 2nd Floor, Sector 63 Noida, 201301</p>\n"
								+ "    </td></tr> \n"
								+ "    </table>";
						
						boolean saveEmail = Enquiry_ACT.saveEmail(email,"empty","Corpseed | Login credentials", message,2,token);
						if(saveEmail)result=saveEmail;
						
						//getting sales name,project no and invoice no
						String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
						//getting current time
						String Time=DateUtil.getCurrentTime();
						//getting primary contact data
						String taskKey=RandomStringUtils.random(40,true,true);	
						String userName=Usermaster_ACT.getLoginUserName(userUid, token);
						String content="Login Credential shared to <span style='color: #4ac4f3;font-weight: 600;'>'"+user[0]+"'</span> by&nbsp;<span style='color: #4ac4f3;font-weight: 600;'>'"+userName+"'</span>";
						String subject="Login Credential Shared";
						//set notification task assigned to team leader	
						TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Notification","bell.png",user[0],user[4],user[1],userUid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA","NA","NA");
									
				}
			}
				}
			
			if(result)out.write("pass");
			else out.write("fail");
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}