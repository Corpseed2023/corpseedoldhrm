package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class UpdateMilestoneDataCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String addedby= (String)session.getAttribute("loginuID");
			String prodrefid = request.getParameter("prodrefid").trim();
			String colname = request.getParameter("colname").trim();
			String val = request.getParameter("val").trim();
			String textboxid = request.getParameter("rowid").trim();
			String token= (String)session.getAttribute("uavalidtokenno");
			
			boolean flag=TaskMaster_ACT.isRowExisted(prodrefid, textboxid, token, "mvid", "milestonevirtualctrl", "mvprodrefid","mvrowid", "mvtoken");
			if(flag){
				flag=TaskMaster_ACT.updateProductMilestoneVirtual(prodrefid,colname,val,textboxid,token);		
			}else{
				flag=TaskMaster_ACT.addProductMilestoneVirtual(prodrefid,colname,val,textboxid,token,addedby);
			}
			
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}