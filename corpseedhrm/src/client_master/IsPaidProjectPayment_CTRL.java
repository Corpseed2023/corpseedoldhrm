package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsPaidProjectPayment_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			
			String token=(String)session.getAttribute("uavalidtokenno");
			String salesKey = request.getParameter("salesKey").trim();
			boolean flag=Clientmaster_ACT.isPaymentDone(salesKey,token);	
			
			if(!flag)pw.write("fail");
			else pw.write("pass");
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
