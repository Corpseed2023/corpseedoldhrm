package billing;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class AddExpenseApprovalCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		PrintWriter pw=response.getWriter();
		try
		{
			HttpSession session=request.getSession();
			
			String expname=request.getParameter("expname").trim();
			String expNumber=request.getParameter("expNumber").trim();
			String expAmount=request.getParameter("expAmount").trim();
			String expCategory=request.getParameter("expCategory").trim();
			String expHSN=request.getParameter("expHSN").trim();
			String expDepartment=request.getParameter("expDepartment").trim();
			String expAccount=request.getParameter("expAccount").trim();
			String expNote=request.getParameter("expNote").trim();
			String salesKey=request.getParameter("salesKey").trim();
			String task_name=request.getParameter("task_name").trim();
			String assignKey=request.getParameter("assignKey").trim();
			String approvalStatus=request.getParameter("approvalStatus").trim();
			String approveBy=request.getParameter("approveBy").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String loginuaid = (String)session.getAttribute("loginuaid");
			if(expHSN.length()<=0)expHSN="NA";
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String domain=properties.getProperty("domain"); 
			
			String expkey=RandomStringUtils.random(40,true,true);
			String today=DateUtil.getCurrentDateIndianFormat1();
			String approvedDate=today;
			if(!approvalStatus.equals("1"))approvedDate="NA";
			boolean flag=Enquiry_ACT.saveForExpenseApproval(expkey,expname,today,expNumber,expAmount,expCategory,expHSN,expDepartment,expAccount,expNote,token,addedby,loginuaid,salesKey,approvalStatus,approveBy,approvedDate,assignKey);				
						
			if(flag&&!salesKey.equalsIgnoreCase("NA")){
				//getting current time
				String Time=DateUtil.getCurrentTime();
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject="Expense("+expCategory+") added";
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
				String content=userName+" has added expense("+expCategory+") of Rs. <b>"+expAmount+"</b> and awaiting for approval."
						+ "<br><b>Comment : </b>"+expNote;
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Expense","expense.png",contactData[0],contactData[1],contactData[2],loginuaid,userName,today+" "+Time,subject,content,addedby,token,"NA","NA","NA","NA","NA");
				
				String accountant[][]=Usermaster_ACT.getAllAccountant(token);
				if(accountant!=null&&accountant.length>0) {
					 //for accountant
					String nKey1=RandomStringUtils.random(40,true,true);
					String nKey2=RandomStringUtils.random(40,true,true);
					String url="";
					if(assignKey.equalsIgnoreCase("NA"))url="assignmytask-"+salesKey+".html";
					else url="edittask-"+assignKey+".html";
					//for added person
					TaskMaster_ACT.addNotification(nKey1,today,loginuaid,"2",url,content,token,loginuaid,"fas fa-rupee-sign");
					//for client
					TaskMaster_ACT.addNotification(nKey2,today,accountant[0][0],"2","manageexpenses.html",content,token,loginuaid,"fas fa-rupee-sign");
					if(task_name==null||task_name.equalsIgnoreCase("NA")||task_name.length()<=0)task_name="";
					else task_name=" for <b>"+task_name+"</b>";
					
					//sending email to accountant for expense approval		
					String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
							+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
							+ "                <a href=\"#\" target=\"_blank\">\n"
							+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
							+ "            </td></tr>\n"
							+ "            <tr>\n"
							+ "              <td style=\"text-align: center;\">\n"
							+ "                <h1>Project - "+salesData[1]+"</h1><p style=\"text-align: center;\">Expense Rs. "+expAmount+" added on "+salesData[0]+"</p>"
							+ "              </td></tr>"
							+ "        <tr>\n"
							+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
							+ "            Hi "+accountant[0][1]+",</td></tr>"
							+ "             <tr>\n"
							+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
							+ "                     <p> Expense("+expCategory+") of Rs. <b>"+expAmount+"</b> has been added on <b>"+salesData[1]+"</b>"+task_name+". Please review the payments to proceed with the order. \n"
							+ "                      </p><p><b>Comment : </b><br>"+expNote+"</p>\n"					
							+ "                    </td></tr>  \n"
							+ "                         <tr>\n"
							+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
							+ "                                  <h2 style=\"text-align: center;\">Action Required</h2>\n"
							+ "                                 <p style=\"text-align: center;\">You have pending approval for expense of Rs. <b>"+expAmount+"</b> that require your attention to proceed. \n"
							+ "                                  </p>\n"
							+ "                                <a href=\""+domain+"manageexpenses.html\"><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">View Expense</button>\n"
							+ "                                </td></tr>  \n"
							+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
							+ "                <b>Project no #"+salesData[1]+"</b><br>\n"
							+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
							+ "                \n"
							+ "    </td></tr> \n"
							+ "    </table>";
					if(accountant[0][2]!=null&&!accountant[0][2].equalsIgnoreCase("NA")&&accountant[0][2].length()>0)
					Enquiry_ACT.saveEmail(accountant[0][2],"empty",salesData[1]+" : Expense awating for approval.", message1,2,token);
				}					
				
			}
			if(flag)pw.write("pass");
			else pw.write("fail");
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
