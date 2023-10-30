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
public class UpdateProductPlan_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter out=response.getWriter();
		boolean status=false;
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String key=request.getParameter("key");
			
			String column=request.getParameter("column").trim();
			
			String colvalue=request.getParameter("colvalue").trim();
			if(column.length()<=0)column="NA";			
			if(colvalue.length()<=0)colvalue="NA";
			
			if(colvalue.equalsIgnoreCase("OneTime")){
				status=Clientmaster_ACT.updateProductPlan(key,colvalue,token);
			}else{
				status=Clientmaster_ACT.updateProductPlan(key,column,colvalue,token);			
			}
			
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