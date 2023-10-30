package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RegisterEditTaxCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String hsn = request.getParameter("hsn").trim();
		String cgst = request.getParameter("cgst").trim();
		String sgst = request.getParameter("sgst").trim();
		String igst = request.getParameter("igst").trim();
		String taxnotes = request.getParameter("taxnotes").trim();
		String key = request.getParameter("key").trim();
		
		String tax[]=TaskMaster_ACT.getOldHsnDetails(hsn,uavalidtokenno);
		boolean flag=TaskMaster_ACT.updateNewTax(key,cgst,sgst,igst,taxnotes,uavalidtokenno);		
		if(!tax[0].equalsIgnoreCase(sgst)||!tax[1].equalsIgnoreCase(cgst)||!tax[2].equalsIgnoreCase(igst)){
			//updating product master's hsn value
			flag=TaskMaster_ACT.updateProductPriceHsn(hsn,sgst,cgst,igst,uavalidtokenno);
		}
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}