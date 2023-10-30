package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsThisPaymentValidCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			String result="fail";
			double orderAmount =Double.parseDouble(request.getParameter("orderAmount").trim());	
			double pymtamount =Double.parseDouble(request.getParameter("pymtamount").trim());	
			String salesno = request.getParameter("salesno").trim();	
			String token = (String)session.getAttribute("uavalidtokenno");
			String pymtmode=request.getParameter("pymtmode").trim();
			
			boolean isPoExist=Enquiry_ACT.isEstimateHavePo(salesno,token);
			if(isPoExist&&pymtmode.equalsIgnoreCase("TAX")) {result="poExist";}else {			
				double paidAmount=Enquiry_ACT.getSalesPaidAmount(salesno,token);
				if(Math.ceil(orderAmount)>=Math.floor(pymtamount+paidAmount))result="pass";
			}
			pw.write(result);
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}
}