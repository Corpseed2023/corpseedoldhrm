package billing;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;

import admin.enquiry.Enquiry_ACT;

public class AddRefundIncomeCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			HttpSession session=request.getSession();
			
			String invoice=request.getParameter("incomerefundinvoice").trim();
			String contactname=request.getParameter("refundincomename").trim();
			String contactmobile=request.getParameter("refundincomemobile").trim();
			String amount=request.getParameter("refundincomeamount").trim();
			String type=request.getParameter("refundrncometype").trim();
			String department=request.getParameter("refundincomedepartment").trim();
			String refunddate=request.getParameter("refundincomedate").trim();
			String notes=request.getParameter("refundincomenotes").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String company=Enquiry_ACT.getCompanyName(invoice, token);
			String laserkey=RandomStringUtils.random(40,true,true);
			String today=DateUtil.getCurrentDateIndianFormat1();
			String remarks="#"+invoice+" - "+notes;
			boolean flag=Enquiry_ACT.saveInTransactionHistory(laserkey,invoice,today,contactname,contactmobile,company,type,Double.parseDouble(amount),0,token,addedby,remarks,"Expense",department,"NA",refunddate);				
			
			if(flag){
				response.sendRedirect(request.getContextPath() + "/managetransactions.html");
			}else{
				session.setAttribute("ErrorMessage", "Something Went Wrong , Try-again later!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

}
