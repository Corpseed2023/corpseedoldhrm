package billing;

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
import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class ApproveThisExpenseCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		PrintWriter pw=response.getWriter();
		try
		{
			HttpSession session=request.getSession();
			
			String expKey=request.getParameter("expKey").trim();
			String approveStatus=request.getParameter("approveStatus").trim();
			String comment=request.getParameter("comment");
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String addedby = (String)session.getAttribute("loginuID");
						
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			boolean flag=Enquiry_ACT.approveThisExpense(expKey,today,loginuaid,token,approveStatus);
			String expense[][]=TaskMaster_ACT.getExpenseData(expKey,token);
			
			String status1="Approved";
			if(approveStatus.equals("3"))status1="Declined";
			else if(approveStatus.equals("4"))status1="On-Hold";
			
			String datetime=DateUtil.getCurrentDateTime();
			String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
			flag=TaskMaster_ACT.saveExpenseComment(expKey,comment,status1,datetime,token,loginuaid,userName);
			
			if(flag&&expense!=null&&!expense[0][18].equalsIgnoreCase("NA")) {				
				String status="<span style=\"color:green\">Approved</span>";
				if(approveStatus.equals("3"))status="<span style=\"color:red\">Not Approved</span>";
				else if(approveStatus.equals("4"))status="<span class=\"text-warning\">On-Hold</span>";
				String salesKey=expense[0][18];
				
				//getting current time
				String Time=DateUtil.getCurrentTime();
				//getting sales name,project no and invoice no
				String salesData[]=TaskMaster_ACT.getSalesData(salesKey,token);
				//getting primary contact data
				String contactData[]=Enquiry_ACT.getClientContactByKey(salesData[3], token);
				String taskKey=RandomStringUtils.random(40,true,true);				
				String subject=salesData[2]+" : Expense Approved";
				if(approveStatus.equalsIgnoreCase("3"))subject=salesData[2]+" : Expense Not Approved";
				else if(approveStatus.equalsIgnoreCase("4"))subject=salesData[2]+" : Expense On-Hold";
				
				
				String content=userName+" has "+status+" the payment of "+expense[0][5]+" for "+expense[0][6]+" on "+today+"."
						+"<br><b>Comment : </b>"+comment;
				//set notification task assigned to team leader	
				flag=TaskMaster_ACT.setTaskNotification(taskKey,salesKey,salesData[0],salesData[1],salesData[2],"Expense","expense.png",contactData[0],contactData[1],contactData[2],loginuaid,userName,today+" "+Time,subject,content,addedby,token,expense[0][15],"NA","NA","NA","NA");
				String[][] user=Usermaster_ACT.getUserByID(expense[0][15]);
				String url="";
				if(expense[0][19].equalsIgnoreCase("NA"))url="assignmytask-"+salesKey+".html";
				else url="edittask-"+expense[0][19]+".html";
				//adding notification to added person
				String nKey1=RandomStringUtils.random(40,true,true);
				TaskMaster_ACT.addNotification(nKey1,today,user[0][0],"2",url,content,token,loginuaid,"fas fa-rupee-sign");
				
				//expense approved email to added person	
				String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">"
						+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">"
						+ "                <a href=\"#\" target=\"_blank\"><img src=\"https://corpseed.com/assets/img/logo.png\"></a></td></tr>"
						+ "            <tr><td style=\"text-align: center;\">"
						+ "                <h1>EXPENSE UPDATE</h1>\n"
						+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>"
						+ "        <tr><td style=\"padding:70px 0 20px;color: #353637;\">"
						+ "            Hi "+user[0][5]+",</td></tr>"
						+ "             <tr><td style=\"padding: 10px 0 15px;color: #353637;\">"
						+ "                     <p> Expense("+expense[0][6]+") of amount <b>"+expense[0][5]+"</b> <b>"+status+"</b>."
						+ "                      </p><p><b>Comment : </b><br>"+comment+"</p></td></tr>"
						+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">"
						+ "                <b>Invoice : #"+salesData[2]+"</b><br>"
						+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p></td></tr></table>";
				
				Enquiry_ACT.saveEmail(user[0][7],"empty",subject+" | Corpseed", message,2,token);
				
			}
			
			if(flag && approveStatus.equals("1")){
				//adding this expense in laser balance				
				if(expense!=null&&expense.length>0) {
					String expensekey=Enquiry_ACT.getExpenseNumber(token);
					String initial = Usermaster_ACT.getStartingCode(token,"imexpensekey");
					if (expensekey==null||expensekey.equalsIgnoreCase("NA") || expensekey.equalsIgnoreCase("")) {
						expensekey=initial+"1";
					}else {
						   String enq=expensekey.substring(initial.length());
						   int j=Integer.parseInt(enq)+1;
						   expensekey=initial+Integer.toString(j);
						}
					String laserkey=RandomStringUtils.random(40,true,true);
					flag=Enquiry_ACT.saveInTransactionHistory(laserkey,expensekey,today,expense[0][3],expense[0][4],expense[0][9],expense[0][6],Double.parseDouble(expense[0][5]),0,token,addedby,expense[0][10],"Expense",expense[0][8],expense[0][7],"00-00-0000");
				}
			}
			
		if(flag){
			pw.write("pass");
		}else{pw.write("fail");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
