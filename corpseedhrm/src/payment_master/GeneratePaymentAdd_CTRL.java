package payment_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class GeneratePaymentAdd_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6805310468528193404L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		try {
			boolean status = false;
			HttpSession session = request.getSession();
			
			String pscuid = request.getParameter("cid").trim();
			
			String pspuid = request.getParameter("pid").trim();
			
			String psinvno = request.getParameter("InVno").trim();
			String psinvamt = request.getParameter("InvoiceAmount").trim();
			String psprcvd = request.getParameter("AmountReceived").trim();
			String pspstatus = request.getParameter("PaymentStatus").trim();
			String psrcvddate = request.getParameter("ReceivingDate").trim();
			String psremark = request.getParameter("shortdescription").trim();
			String cbstatus = request.getParameter("Status").trim();
			String cbdate = request.getParameter("NextBillingDate").trim();

//			status = Clientmaster_ACT.saveGeneratedPayment(pscuid,pspuid, psinvno,psinvamt,psprcvd,pspstatus,psrcvddate,psremark);
//			status = Clientmaster_ACT.saveBillingDate(pspuid,cbstatus,cbdate);
//			status = Clientmaster_ACT.saveReceivingDate(psinvno,psrcvddate,pspstatus);
//			Clientmaster_ACT.saveToAccount(pscuid, psprcvd, psremark, (String) session.getAttribute("loginuID"), psrcvddate);
//			
			if (status) {
				session.setAttribute("ErrorMessage", "Payment is Successfully saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			} else {
				session.setAttribute("ErrorMessage", "Payment is not saved!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
		}
		catch (Exception e) {
		}
	}
}