package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateMainProductsPriceCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String colname = request.getParameter("colname").trim();
			String val = request.getParameter("val").trim();
			String uid = request.getParameter("uid").trim();
			String token = (String) session.getAttribute("uavalidtokenno");
			
			boolean	flag=TaskMaster_ACT.updateProductPrice(colname,val,uid);				
			
			if(colname.equalsIgnoreCase("pp_price")){
				TaskMaster_ACT.clearTaxTotal(uid,val);
			}else if(colname.equalsIgnoreCase("pp_hsncode")){
				String tax[]=TaskMaster_ACT.getTaxByHSN(val,token);
				String sgst="0";
				String cgst="0";
				String igst="0";
				if(tax[0]!=null&&tax[0].length()>0)sgst=tax[0];
				if(tax[1]!=null&&tax[1].length()>0)cgst=tax[1];
				if(tax[2]!=null&&tax[2].length()>0)igst=tax[2];
				if(sgst.equalsIgnoreCase("0")&&cgst.equalsIgnoreCase("0")&&igst.equalsIgnoreCase("0"))val="NA";
				TaskMaster_ACT.updateMainTaxDetails(uid,token,val,sgst,cgst,igst);	 		
			}
			
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}