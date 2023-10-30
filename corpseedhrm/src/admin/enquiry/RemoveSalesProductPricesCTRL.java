package admin.enquiry;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class RemoveSalesProductPricesCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		boolean status=false;
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String salesrefidrefid=request.getParameter("salesrefidrefid");
			if(salesrefidrefid!=null&&salesrefidrefid.length()>0){
				status=Clientmaster_ACT.removeSalesProductPrice(salesrefidrefid,token);
				status=Clientmaster_ACT.removeSalesProductPlan(salesrefidrefid,token);
			}			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}