package billing;

import hcustbackend.ClientACT;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class IsMultipleItemExists_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
	
		try
		{
			PrintWriter pw=response.getWriter();
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String type=request.getParameter("tablefrom").trim();
			String cuid=request.getParameter("cuid").trim();
			boolean flag=ClientACT.isMultipleProjectsItem(type,token,cuid);	
			if(!flag)pw.write("pass");
			else pw.write("fail");
		}catch (Exception e) {
		 e.printStackTrace();
		}
	}

}
