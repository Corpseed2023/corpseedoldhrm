package invoice_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class GenerateInvoiceEdit_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4669325208837045611L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession();

			String uid = request.getParameter("uid").trim();
			String giinvno = request.getParameter("InVno").trim();

			String gicuid = request.getParameter("cid").trim();

			String gipuid = request.getParameter("pid").trim();
			
			String giinvamt = request.getParameter("InvoiceAmount").trim();
			String giservicecode = request.getParameter("ServiceCode").trim();
			String gicategory = request.getParameter("GSTCategory").trim();
			String gigst = request.getParameter("GST").trim();
			String gigstamt = request.getParameter("GSTValue").trim();
			String gitotal = request.getParameter("TotalInvoiceAmount").trim();
			String gibmonth = request.getParameter("BillingMonth").trim();
			String gibdate = request.getParameter("BillingDate").trim();
			String giremark = request.getParameter("shortdescription").trim();
			String billingamount = request.getParameter("BillingAmount").trim();
			double dueamount = Double.parseDouble(billingamount) - Double.parseDouble(giinvamt); 

			status = Clientmaster_ACT.UpdateGeneratedInvoice(uid, giinvno, gicuid, gipuid, giinvamt, gigst, gigstamt, gitotal, gibmonth, gibdate, giremark,giservicecode,gicategory, billingamount, dueamount);
			status = Clientmaster_ACT.updateGST(gibmonth,gicategory,gigst,gigstamt,gicuid, gipuid, billingamount, giinvamt,giinvno);
			
			if (status) {
				session.setAttribute("ErrorMessage", "Invoice is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "Invoice is not saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}

		catch (Exception e) {
			
		}

	}

}