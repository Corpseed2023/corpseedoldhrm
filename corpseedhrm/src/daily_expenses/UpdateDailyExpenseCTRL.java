package daily_expenses;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateDailyExpenseCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		
		boolean status=false;
		HttpSession session = request.getSession();
		String token = (String) session.getAttribute("uavalidtokenno");
		String addedby = (String) session.getAttribute("loginuID");
		
		String custid = request.getParameter("custid").trim();
		String Amount = request.getParameter("Amount").trim();
		String PaidTo= request.getParameter("Paid To").trim();
		String ExpensesCategory= request.getParameter("ExpensesCategory").trim();
		String Description= request.getParameter("Description").trim();
		String PaymentMode= request.getParameter("PaymentMode").trim();
		String ApprovedBy= request.getParameter("ApprovedBy").trim();
		String PaidDate= request.getParameter("PaidDate").trim();
		String invoiceno= request.getParameter("invoiceno").trim();
		String place= request.getParameter("place").trim();
		String servicecode= request.getParameter("servicecode").trim();
		String gstcategory= request.getParameter("gstcategory").trim();
		String gsttax= request.getParameter("gsttax").trim();
		String gstvalue= request.getParameter("gstvalue").trim();
		String totalinvoiceamount= request.getParameter("totalinvoiceamount").trim();
		String gst= request.getParameter("gst").trim();
		status=Daily_Expenses_ACT.updateDailyExpenses(Amount,PaidTo, ExpensesCategory, Description, PaymentMode, ApprovedBy, PaidDate, addedby,token, invoiceno, place, servicecode, gstcategory, gsttax, gstvalue, totalinvoiceamount,gst,custid);
		if (status){
//			session.setAttribute("ErrorMessage", "New Daily Expenses is Successfully Added!.");
			response.sendRedirect(request.getContextPath()+"/Manage-Daily-Expense.html");
		}
		else {
			session.setAttribute("ErrorMessage", "New Daily Expenses is not Added!.");
			response.sendRedirect(request.getContextPath()+"/notification.html");
		}
	}
}

