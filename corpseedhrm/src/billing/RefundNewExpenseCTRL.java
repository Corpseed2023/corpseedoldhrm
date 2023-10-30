package billing;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class RefundNewExpenseCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			HttpSession session=request.getSession();
			
			String name=request.getParameter("refundexpensename").trim();
			String contactnumber=request.getParameter("refundexpenseContactNumber").trim();
			String amount=request.getParameter("refundexpenseamount").trim();
			String category=request.getParameter("refundExpenseCategory").trim();
			String hsn=request.getParameter("refundexpensehsncode").trim();
			String department=request.getParameter("refundexpensedepartment").trim();
			String account=request.getParameter("refundPaidFromAccount").trim();
			String notes=request.getParameter("refundexpensenote").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			
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
			String today=DateUtil.getCurrentDateIndianFormat1();
			String remarks="#"+expensekey+" - "+notes;
			boolean flag=Enquiry_ACT.saveInTransactionHistory(laserkey,expensekey,today,name,contactnumber,account,category,0,Double.parseDouble(amount),token,addedby,remarks,"Expense",department,hsn,"00-00-0000");				
			
			if(flag){
				response.sendRedirect(request.getContextPath() + "/managetransactions.html");
			}else{
				session.setAttribute("ErrorMessage", "Something Went Wrong , Try-again later!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}catch (Exception e) {
		
		}
	}

}
