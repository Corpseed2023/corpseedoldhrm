package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class RemoveProductPricesCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		PrintWriter out=response.getWriter();
		boolean status=false;
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String pricedivrefid=request.getParameter("pricedivrefid");
			if(pricedivrefid.length()>0&&pricedivrefid!=null){
				status=Clientmaster_ACT.removeProductPrice(pricedivrefid,token);
//				status=Clientmaster_ACT.removeRegisteredPayment(pricedivrefid,token);
				status=Clientmaster_ACT.removeProductPlan(pricedivrefid,token);
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}