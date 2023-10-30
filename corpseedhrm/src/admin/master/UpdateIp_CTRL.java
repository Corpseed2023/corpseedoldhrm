package admin.master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateIp_CTRL extends HttpServlet{
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException,ServletException
	{
		PrintWriter pw=response.getWriter();
		try
		{
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
						
			String ip=request.getParameter("ip").trim();
			String uaid=request.getParameter("uaid").trim();
			
			 if(ip==null||ip.length()<=0||ip.equalsIgnoreCase("NA")) {
				pw.write("invalid"); 
			 }else {
				 boolean flag=Usermaster_ACT.updateUserIp(ip,uaid,token);
				 if(flag)pw.write("pass");
			 }
			
		}catch (Exception e) {
			pw.write("fail");
			e.printStackTrace();
		}
	}

}
