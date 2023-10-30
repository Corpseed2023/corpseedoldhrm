package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RegisterNewTaxCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		String hsn = request.getParameter("hsn").trim();
		String cgst = request.getParameter("cgst").trim();
		String sgst = request.getParameter("sgst").trim();
		String igst = request.getParameter("igst").trim();
		String taxnotes = request.getParameter("taxnotes").trim();
		String key = request.getParameter("key").trim();
		
		boolean flag=TaskMaster_ACT.addNewTax(key,hsn,cgst,sgst,igst,taxnotes,uavalidtokenno,loginuID);
		if(flag){
			flag=TaskMaster_ACT.updateProductPriceHsn(hsn,sgst,cgst,igst,uavalidtokenno);
		}
		if(flag){			
			pw.write("pass");
		}
		else pw.write("fail");
	}

}