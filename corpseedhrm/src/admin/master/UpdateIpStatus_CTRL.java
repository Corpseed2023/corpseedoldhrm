package admin.master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateIpStatus_CTRL extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException,ServletException
	{
		PrintWriter pw=response.getWriter();
		try
		{
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginuaid= (String)session.getAttribute("loginuaid");
						
			String status=request.getParameter("status").trim();
			String uaid=request.getParameter("uaid").trim();
			 
			 boolean flag=Usermaster_ACT.updateUserIpStatus(status,uaid,token,loginuaid);
			 if(flag)pw.write("pass");
			 
		}catch (Exception e) {
			pw.write("fail");
			e.printStackTrace();
		}
	}

}
