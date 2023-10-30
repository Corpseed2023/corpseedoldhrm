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
public class UpdateProductsQtyDirect_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String addedby= (String)session.getAttribute("loginuID");
			
			String prodvirtualid=request.getParameter("prodvirtualid");
			if(prodvirtualid!=null)prodvirtualid=prodvirtualid.trim();
			
			String prodqty=request.getParameter("prodqty");
			if(prodqty!=null)prodqty=prodqty.trim();
			
			String result="NA";
			String qty=Clientmaster_ACT.getProductQuantity(prodvirtualid,prodqty,token,addedby);
//			System.out.println("qqqqq="+qty);
			if(Integer.parseInt(prodqty)<=0){				
				result="Not#"+qty;
			}else{
			boolean status=Clientmaster_ACT.updateQtyOfProductDirect(prodvirtualid,prodqty,token,addedby);
			
				if(status){
					result="pass#1";
				}else{
					result="fail#"+qty;
				}
			}
//			System.out.println(result);
			pw.write(result);
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}