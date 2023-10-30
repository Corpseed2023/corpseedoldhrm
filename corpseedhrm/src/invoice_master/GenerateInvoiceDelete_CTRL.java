package invoice_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import client_master.Clientmaster_ACT;

public class GenerateInvoiceDelete_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 7123625288257641317L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String uid = request.getParameter("info").trim();
			Clientmaster_ACT.deleteInvoice(uid);

		} catch (Exception e) {
			
		}

	}
}
