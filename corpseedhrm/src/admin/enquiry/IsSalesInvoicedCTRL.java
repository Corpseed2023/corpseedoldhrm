package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsSalesInvoicedCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			String result="fail";
			String salesno = request.getParameter("salesno").trim();	
			String token = (String)session.getAttribute("uavalidtokenno");
			
			boolean flag=Enquiry_ACT.isInvoiceConverted(salesno,token);
			
			if(flag)result="pass";
			
			pw.write(result);
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}
}