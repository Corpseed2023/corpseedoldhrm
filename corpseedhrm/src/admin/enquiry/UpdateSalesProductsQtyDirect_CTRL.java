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
public class UpdateSalesProductsQtyDirect_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String prodrefid=request.getParameter("prodrefid");
			if(prodrefid!=null)prodrefid=prodrefid.trim();
			
			String prodqty=request.getParameter("prodqty");
			if(prodqty!=null)prodqty=prodqty.trim();
			
			int updateqty=Integer.parseInt(prodqty);
			//getting current product's quantity
			int previouqty=Clientmaster_ACT.getCurrentProductQty(prodrefid,token);
			if(updateqty<=0){
				pw.write("Not#"+previouqty);
			}else{
			boolean status=Clientmaster_ACT.updateSalesQtyOfProduct(prodrefid,prodqty,token);
			
			if(status){				
				//update product's all price
				String productprice[][]=Enquiry_ACT.getSalesProductPrice(prodrefid, token);
				if(productprice!=null&&productprice.length>0){
					for(int i=0;i<productprice.length;i++){
						double price=(Double.parseDouble(productprice[i][2])/previouqty)*updateqty;
						double cgstprice=(Double.parseDouble(productprice[i][5])/previouqty)*updateqty;
						double sgstprice=(Double.parseDouble(productprice[i][6])/previouqty)*updateqty;
						double igstprice=(Double.parseDouble(productprice[i][7])/previouqty)*updateqty;
						double totalprice=(Double.parseDouble(productprice[i][8])/previouqty)*updateqty;
						status=Enquiry_ACT.updateSaleProductPrice(productprice[i][0],price,cgstprice,sgstprice,igstprice,totalprice,token);
					}
				}
				pw.write("pass#1");
			}else{
				pw.write("fail#"+previouqty);
			}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}