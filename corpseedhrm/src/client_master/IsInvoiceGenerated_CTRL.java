package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsInvoiceGenerated_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter p=response.getWriter();
		try {
			HttpSession session=request.getSession();
			
			String token=(String)session.getAttribute("uavalidtokenno");
			String invoiceType=request.getParameter("invoiceType").trim();
			String invoiceNo=request.getParameter("invoiceNo").trim();
			boolean status=Clientmaster_ACT.isInvoiceGenerated(invoiceType, invoiceNo, token);
			if(status)
				p.write("pass");
			else
				p.write("fail");
			
		}catch (Exception e) {
			p.write("fail");
		}

	}

}