package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class AddProduct_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		PrintWriter pw=response.getWriter();
		   
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		String servicetype = request.getParameter("servicetype").trim();
		String productname = request.getParameter("productname").trim();
		String productremarks = request.getParameter("productremarks").trim();
		String prodno=request.getParameter("prodno").trim();		
		String key=request.getParameter("key").trim();	
		
		boolean servicetypeid=TaskMaster_ACT.isProductTypeExist(servicetype,uavalidtokenno);
		if(!servicetypeid){
			TaskMaster_ACT.addServiceType(servicetype, uavalidtokenno, loginuID);
		}
		boolean flag=TaskMaster_ACT.addProduct(productname,productremarks,uavalidtokenno,loginuID,servicetype,prodno,key);		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}