package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateProduct_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String servicetype = request.getParameter("servicetype").trim();
			String productname = request.getParameter("productname").trim();
			String productremarks = request.getParameter("productremarks").trim();
			String prodrefid = request.getParameter("prodrefid").trim();
			String token = (String) session.getAttribute("uavalidtokenno");
			String addedby = (String) session.getAttribute("loginuID");
			
			boolean servicetypeid=TaskMaster_ACT.isProductTypeExist(servicetype,token);
			if(!servicetypeid){
				TaskMaster_ACT.addServiceType(servicetype, token, addedby);
			}
			
			boolean flag=TaskMaster_ACT.updateProduct(prodrefid,servicetype,productname,productremarks);		
		if(flag){pw.write("pass");}else{pw.write("fail");}
	}

}