package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


public class ClientPassUpdateCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw=response.getWriter();
		
		HttpSession session=request.getSession();
		String loginuaid=(String)session.getAttribute("loginuaid");		
				
		String crpass=request.getParameter("crpass").trim();
		String nwpass=request.getParameter("nwpass").trim();
		
		boolean flag=ClientACT.updateClientPassword(loginuaid,crpass,nwpass);
		
		if(flag)
			pw.write("pass");
		else
			pw.write("fail");
	}

}
