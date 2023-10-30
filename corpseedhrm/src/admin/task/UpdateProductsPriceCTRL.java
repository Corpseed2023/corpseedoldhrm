package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateProductsPriceCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String addedby= (String)session.getAttribute("loginuID");
			String prodrefid = request.getParameter("prodrefid").trim();
			String colname = request.getParameter("colname").trim();
			String val = request.getParameter("val").trim();
			String textboxid = request.getParameter("rowid").trim();
			String token= (String)session.getAttribute("uavalidtokenno");
			
			boolean flag=TaskMaster_ACT.isRowExisted(prodrefid,textboxid,token,"ppvid","productpricevirtual","ppvproductrefid","ppvtextboxid","ppvtoken");
			if(flag){
				flag=TaskMaster_ACT.updateProductPriceVirtual(prodrefid,colname,val,textboxid,token);				
			}else{
				flag=TaskMaster_ACT.addProductPriceVirtual(prodrefid,colname,val,textboxid,token,addedby);
			}
			if(colname.equalsIgnoreCase("ppvprice")){
				TaskMaster_ACT.clearTaxTotal(prodrefid,textboxid,token,val);
			}else if(colname.equalsIgnoreCase("ppvhsncode")){
				String tax[]=TaskMaster_ACT.getTaxByHSN(val,token);
				String sgst="NA";
				String cgst="NA";
				String igst="NA";
				if(tax[0]!=null&&tax[0].length()>0)sgst=tax[0];
				if(tax[1]!=null&&tax[1].length()>0)cgst=tax[1];
				if(tax[2]!=null&&tax[2].length()>0)igst=tax[2];
				TaskMaster_ACT.updateTaxDetails(prodrefid,textboxid,token,sgst,cgst,igst);			
			}
			
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}