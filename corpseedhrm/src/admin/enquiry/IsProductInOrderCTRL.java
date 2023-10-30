package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsProductInOrderCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			
			String prodrefid = request.getParameter("prodrefid").trim();	
			String salesno = request.getParameter("salesno").trim();	
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			
			status=Enquiry_ACT.isProductInOrder(prodrefid,salesno,token,addedby);
					
			if (status) {				
				pw.write("pass");
			} else {
				pw.write("fail");
			}
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}
}