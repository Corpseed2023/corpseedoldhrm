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
public class UpdateSalesProductPlan_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		boolean status=false;
		try {
			HttpSession session = request.getSession(); 
			
			String token=(String)session.getAttribute("uavalidtokenno");			
			String prodrefid=request.getParameter("prodrefid");
			if(prodrefid!=null)prodrefid=prodrefid.trim();
			
			String value=request.getParameter("value").trim();
			String colname=request.getParameter("colname").trim();
//			System.out.println(prodrefid+"/"+value+"/"+colname);
				status=Clientmaster_ACT.updateSalesProductPlan(colname,value,prodrefid,token);
			
			if(status){
				out.write("pass");
			}else{
				out.write("fail");
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}