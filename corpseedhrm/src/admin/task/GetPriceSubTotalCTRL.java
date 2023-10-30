package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class GetPriceSubTotalCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter(); 		
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");				
			String prodrefid = request.getParameter("prodrefid").trim();			
			
			double virtualprice=0;
			double mainprice=0;
			double total=0;
			
				virtualprice=TaskMaster_ACT.getVirtualProductPrice(prodrefid,uavalidtokenno,loginuID);
				mainprice=TaskMaster_ACT.getProductPrice(prodrefid, uavalidtokenno);
				total=virtualprice+mainprice;
//				System.out.println("subtotal=="+subtotal);		
				pw.write(total+"");			
			
	}

}