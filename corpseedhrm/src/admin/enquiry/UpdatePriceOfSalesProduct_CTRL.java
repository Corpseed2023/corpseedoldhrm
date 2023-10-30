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
public class UpdatePriceOfSalesProduct_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String price=request.getParameter("price");
			if(price!=null)price=price.trim();
			
			String pricerefid=request.getParameter("refid");
			if(pricerefid!=null)pricerefid=pricerefid.trim();
			
			String cgstprice=request.getParameter("cgstprice");
			if(cgstprice!=null)cgstprice=cgstprice.trim();
			
			String sgstprice=request.getParameter("sgstprice");
			if(sgstprice!=null)sgstprice=sgstprice.trim();
			
			String igstprice=request.getParameter("igstprice");
			if(igstprice!=null)igstprice=igstprice.trim();
			
			String prodrefid=request.getParameter("pricerefid");
			if(prodrefid!=null)prodrefid=prodrefid.trim();
			
			boolean status=Clientmaster_ACT.updatePriceOfSalesProduct(price,pricerefid,cgstprice,sgstprice,igstprice,token);
			double subtotal=0;
			if(status){
				String salesType=Enquiry_ACT.findSalesTypeByKey(prodrefid, token);
				if(salesType.equals("2"))
					Enquiry_ACT.updateConsultingSale(prodrefid,price,cgstprice,sgstprice,igstprice,token);
				
				subtotal=Clientmaster_ACT.getTotalSalesPrice(prodrefid,token);
				out.write("pass#"+subtotal);
			}else{
				out.write("fail#"+subtotal);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}