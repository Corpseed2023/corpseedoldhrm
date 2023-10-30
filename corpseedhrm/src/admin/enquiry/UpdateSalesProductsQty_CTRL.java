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
public class UpdateSalesProductsQty_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			
			String prodrefid=request.getParameter("prodrefid");
			if(prodrefid!=null)prodrefid=prodrefid.trim();
			
			String prodqty=request.getParameter("prodqty");
			if(prodqty!=null)prodqty=prodqty.trim();
			
			String action=request.getParameter("action");
			if(action!=null)action=action.trim();
			
			//getting current product's quantity
			int orgqty=Clientmaster_ACT.getCurrentProductQty(prodrefid,token);
			if(action.equalsIgnoreCase("minus")&&prodqty.equalsIgnoreCase("1")){
				pw.write("Not");
			}else{
			boolean status=Clientmaster_ACT.updateSalesQtyOfProduct(prodrefid,action,token);
			
			if(status){
				int qty=orgqty;
				//update product's all price
				String productprice[][]=Enquiry_ACT.getSalesProductPrice(prodrefid, token);
				if(productprice!=null&&productprice.length>0&&qty>0){
					if(action.equalsIgnoreCase("minus")){qty-=1;}else if(action.equalsIgnoreCase("plus")){qty+=1;}
					for(int i=0;i<productprice.length;i++){
						double price=(Double.parseDouble(productprice[i][2])/orgqty)*qty;
						double cgstprice=(Double.parseDouble(productprice[i][5])/orgqty)*qty;
						double sgstprice=(Double.parseDouble(productprice[i][6])/orgqty)*qty;
						double igstprice=(Double.parseDouble(productprice[i][7])/orgqty)*qty;
						double totalprice=(Double.parseDouble(productprice[i][8])/orgqty)*qty;
						status=Enquiry_ACT.updateSaleProductPrice(productprice[i][0],price,cgstprice,sgstprice,igstprice,totalprice,token);
					}
				}
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