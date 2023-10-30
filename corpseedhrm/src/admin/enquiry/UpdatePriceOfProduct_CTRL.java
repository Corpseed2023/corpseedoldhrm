package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class UpdatePriceOfProduct_CTRL extends HttpServlet {

	private static final long serialVersionUID = 6143815125411746024L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String price=request.getParameter("price").trim();
			String vrefid=request.getParameter("vrefid").trim();
			String pricerefid=request.getParameter("pricerefid").trim();
			
			boolean status=Clientmaster_ACT.updatePriceOfProduct(price,vrefid,token);
			double subtotal=0;
			double totalwithgst=0;
			if(status){
				subtotal=Clientmaster_ACT.getTotalVirtualPrice(pricerefid,token);
				totalwithgst=Clientmaster_ACT.getTotalVirtualPriceWithGst(pricerefid,token);
//				System.out.println("totalwithgst="+totalwithgst);
				out.write("pass#"+subtotal+"#"+totalwithgst);
			}else{
				out.write("fail#"+subtotal+"#"+totalwithgst);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}