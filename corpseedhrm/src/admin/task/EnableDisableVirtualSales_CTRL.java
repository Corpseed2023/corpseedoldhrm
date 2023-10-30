package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class EnableDisableVirtualSales_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String salesrefid = request.getParameter("salesrefid").trim();			
			String status = request.getParameter("status").trim();	
			String token = (String) session.getAttribute("uavalidtokenno");
			String addedby = (String) session.getAttribute("loginuID");
						
			boolean flag=TaskMaster_ACT.updateVirtualSalesHierarchy(salesrefid,status,token,addedby);	
			
		if(flag){pw.write("pass");}else{pw.write("fail");}
	}

}