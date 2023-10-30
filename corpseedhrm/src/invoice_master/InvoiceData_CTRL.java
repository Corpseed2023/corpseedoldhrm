package invoice_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import client_master.Clientmaster_ACT;

public class InvoiceData_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -2286678774441738672L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			String pid = request.getParameter("pid").trim();

			String InvoiceNo = "";
			String InvoiceAmount = "";
			
			String getInvoiceData[][] = Clientmaster_ACT.getInvoiceData(pid);

			InvoiceNo = getInvoiceData[0][0];
			InvoiceAmount = getInvoiceData[0][1];
			
			PrintWriter pw = response.getWriter();
			pw.write(InvoiceNo + "#" + InvoiceAmount);

		} catch (Exception e) {
			
		}

	}
}
