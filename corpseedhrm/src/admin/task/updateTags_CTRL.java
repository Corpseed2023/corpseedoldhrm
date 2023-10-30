package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class updateTags_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
			String value = request.getParameter("value").trim();
			String salesrefid = request.getParameter("salesrefid").trim();			
			String token= (String)session.getAttribute("uavalidtokenno");
//			System.out.println(value+"/"+salesrefid);
			boolean flag=TaskMaster_ACT.updateSaleTags(value, salesrefid, token);
		
		if(flag)pw.write("pass");
		else pw.write("fail");
	}

}