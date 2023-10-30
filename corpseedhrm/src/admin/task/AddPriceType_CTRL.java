package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import hcustbackend.ClientACT;

public class AddPriceType_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			
			HttpSession session = request.getSession(); 

			String token = (String)session.getAttribute("uavalidtokenno");
			String loginuaid = (String)session.getAttribute("loginuaid");
			boolean flag=false;
			String estKey=request.getParameter("estKey").trim();
			String priceType=request.getParameter("priceType").trim();
			String typePrice=request.getParameter("typePrice").trim();
			String typePriceHsn=request.getParameter("typePriceHsn");
			if(typePriceHsn==null||typePriceHsn.length()<=0)typePriceHsn="NA";
			
			String[][] estSales=Enquiry_ACT.getEstimateSaleData(estKey, token);
			if(estSales!=null&&estSales.length>0) {
				
				String prodrefid=Enquiry_ACT.getProductKeyByTypeAndName(estSales[0][3],estSales[0][4],token);
				
				String clientStateCode=ClientACT.getClientDataByKey(estSales[0][2], token);
				String cstatecode="NA";
				String comp[]=Enquiry_ACT.getCompanyDetail(token);
				if(comp[0]!=null&&!comp[0].equalsIgnoreCase("NA")){cstatecode=comp[0].trim();}
				else if(comp[1]!=null&&!comp[1].equalsIgnoreCase("NA")){cstatecode=comp[0].substring(0,2);}
				
				double cgstprice=0;
				double sgstprice=0;
				double igstprice=0;
				double totalprice=0;						
				double cgst=0;
				double sgst=0;
				double igst=0;
				double price=Double.parseDouble(typePrice);
				
				if(!typePriceHsn.equalsIgnoreCase("NA")) {
					String hsn[]=TaskMaster_ACT.getTaxByHSN(typePriceHsn, token);
					if(hsn[0]!=null)
						sgst=Double.parseDouble(hsn[0]);
					if(hsn[1]!=null)
						cgst=Double.parseDouble(hsn[1]);
					if(hsn[2]!=null)
						igst=Double.parseDouble(hsn[2]);
					
					if(cstatecode.equalsIgnoreCase(clientStateCode)){
						cgstprice=(price*cgst)/100;
						sgstprice=(price*sgst)/100;
						 totalprice=price+cgstprice+sgstprice;
						 igst=0;
					}else{
						igstprice=(price*igst)/100;
						totalprice=price+igstprice;
						sgst=0;
						cgst=0;
					}
				}else totalprice=price;
				
				if(prodrefid!=null)
					flag=Enquiry_ACT.saveSalesProductPrice(estSales[0][0],prodrefid,priceType,
							price,typePriceHsn,cgst,sgst,igst,cgstprice,sgstprice,igstprice,
							totalprice,RandomStringUtils.random(40,true,true),token,loginuaid,
							estKey,typePrice);
				
			}
		if(flag)pw.write("pass");
		else pw.write("fail");
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}