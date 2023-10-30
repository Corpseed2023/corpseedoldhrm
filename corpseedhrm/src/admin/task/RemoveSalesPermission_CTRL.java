package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RemoveSalesPermission_CTRL extends HttpServlet {	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			String token= (String)session.getAttribute("uavalidtokenno");
			
			String salesId = request.getParameter("salesId").trim();	
		    String uaid = request.getParameter("id").trim();
		    if(uaid==null||uaid.length()<=0)uaid="0";
			
			boolean flag=TaskMaster_ACT.removeSalesPermission(salesId,uaid,token);
			
			if(flag)pw.write("pass");
			else pw.write("fail");
	}

}