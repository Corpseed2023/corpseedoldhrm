package daily_expenses;
import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Add_Daily_ExpensesCTRL extends HttpServlet{
	private static final long serialVersionUID = 1L;
	public void doPost(HttpServletRequest request,HttpServletResponse response) {
		try {
			RequestDispatcher rd=null;
			HttpSession session =request.getSession();
			String uavalidtokenno111= (String)session.getAttribute("uavalidtokenno");
			String uaIsValid= (String)session.getAttribute("loginuID");
			if(uaIsValid== null || uaIsValid.equals("") || uavalidtokenno111== null || uavalidtokenno111.equals("")){
				rd=request.getRequestDispatcher("/login.html");
				rd.forward(request, response);
			}
			boolean status=false;
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
			String token=(String)session.getAttribute("uavalidtokenno");

			status=Daily_Expenses_ACT.saveDailyExpenses(Amount,PaidTo, ExpensesCategory, Description, PaymentMode, ApprovedBy, PaidDate, uaIsValid,token, invoiceno, place, servicecode, gstcategory, gsttax, gstvalue, totalinvoiceamount,gst);
			if (status){
//				session.setAttribute("ErrorMessage", "New Daily Expenses is Successfully Added!.");
				response.sendRedirect(request.getContextPath()+"/Manage-Daily-Expense.html");
			}
			else {
				session.setAttribute("ErrorMessage", "New Daily Expenses is not Added!.");
				response.sendRedirect(request.getContextPath()+"/notification.html");
			}
			

		}catch (Exception e) {

		}
	}

}