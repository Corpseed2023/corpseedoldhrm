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

public class AddNewExpenseCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			HttpSession session=request.getSession();
			
			String name=request.getParameter("addexpensename").trim();
			String contactnumber=request.getParameter("addexpenseContactNumber").trim();
			String amount=request.getParameter("addexpenseamount").trim();
			String category=request.getParameter("addExpenseCategory").trim();
			String hsn=request.getParameter("addexpensehsncode").trim();
			String department=request.getParameter("addexpensedepartment").trim();
			String account=request.getParameter("addPaidFromAccount").trim();
			String notes=request.getParameter("addexpensenote").trim();
			
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
			boolean flag=Enquiry_ACT.saveInTransactionHistory(laserkey,expensekey,today,name,contactnumber,account,category,Double.parseDouble(amount),0,token,addedby,remarks,"Expense",department,hsn,"00-00-0000");				
			
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
