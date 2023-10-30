package invoice_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class GetInvoiceNoCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session=request.getSession();
		String initial = request.getParameter("cbinvno");
		String uacompany= (String)session.getAttribute("uacompany");

		String invno = Clientmaster_ACT.getinvoicecode(initial,uacompany);

		if (invno == null) {
			invno = initial+"1";
		} else {
			String lastid = Clientmaster_ACT.getinvoicecodeinitial(initial, uacompany);
			if(!initial.equals(lastid)) {
				invno=initial+"1";
			}
			else {
				int j=Integer.parseInt(invno)+1;
				invno=initial+Integer.toString(j);
			}
		}

		PrintWriter pw = response.getWriter();
		pw.write(invno);
	}
}