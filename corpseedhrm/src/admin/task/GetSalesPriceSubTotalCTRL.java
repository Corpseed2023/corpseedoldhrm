package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class GetSalesPriceSubTotalCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter(); 		
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
//		String loginuID = (String) session.getAttribute("loginuID");	
		
			String refkey = request.getParameter("refkey").trim();	
			String totaltax = request.getParameter("totaltax").trim();	
			String totalamt = request.getParameter("totalamt").trim();	
			String select2val = request.getParameter("select2val").trim();			
			String pricekey = request.getParameter("pricekey").trim();			
			
			boolean flag=TaskMaster_ACT.updateSalePriceVirtualTaxTotal(refkey,totaltax,totalamt,uavalidtokenno,select2val);				
			
			double totalprice=0;			
			if(flag){
				totalprice=TaskMaster_ACT.getVirtualProductSalePrice(pricekey,uavalidtokenno);				
//				System.out.println("subtotal=="+totalprice);		
				pw.write("pass#"+totalprice);
			}else pw.write("fail#"+totalprice);
			
	}

}