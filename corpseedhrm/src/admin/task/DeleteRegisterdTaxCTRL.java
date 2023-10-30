package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class DeleteRegisterdTaxCTRL extends HttpServlet {
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			PrintWriter pw=response.getWriter();
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String mtrefid=request.getParameter("mtrefid");
			if(mtrefid!=null)mtrefid=mtrefid.trim();
			
			boolean flag=TaskMaster_ACT.delRegisteredTax(mtrefid,token);
			if(flag){
				pw.write("pass");
			}else{
				pw.write("fail");
			}
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}
