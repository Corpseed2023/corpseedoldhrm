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
public class UpdateProductsQty_CTRL extends HttpServlet {

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
			
			String action=request.getParameter("action");
			if(action!=null)action=action.trim();
			
			if(action.equalsIgnoreCase("minus")&&prodqty.equalsIgnoreCase("1")){
				pw.write("Not");
			}else{
			boolean status=Clientmaster_ACT.updateQtyOfProduct(prodvirtualid,action,token,addedby);
			
			if(status){
				pw.write("pass");
			}else{
				pw.write("fail");
			}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}