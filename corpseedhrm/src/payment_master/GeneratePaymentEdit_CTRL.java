package payment_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class GeneratePaymentEdit_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -6986004253547884390L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		try {
			boolean status = false;
			HttpSession session = request.getSession();
			
			String psuid = request.getParameter("uid").trim();
			
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

//			status = Clientmaster_ACT.updateGeneratedPayment(psuid, pscuid,pspuid, psinvno,psinvamt,psprcvd,pspstatus,psrcvddate,psremark);
//			boolean status2 = Clientmaster_ACT.saveBillingDate(pspuid,cbstatus,cbdate);
			
//			if (status == true && status2 == true) {
//				session.setAttribute("ErrorMessage", "Payment is Successfully updated!");
//				response.sendRedirect(request.getContextPath() + "/notification.html");
//			} else {
//				session.setAttribute("ErrorMessage", "Payment is not updated!");
//				response.sendRedirect(request.getContextPath() + "/notification.html");
//			}
		}

		catch (Exception e) {
			
		}

	}

}