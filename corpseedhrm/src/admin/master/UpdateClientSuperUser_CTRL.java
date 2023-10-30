package admin.master;

import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class UpdateClientSuperUser_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{  
	HttpSession session =request.getSession();	
	PrintWriter out=response.getWriter();
	String token = (String)session.getAttribute("uavalidtokenno");
	
	String super_name = request.getParameter("super_name").trim();
	String super_email = request.getParameter("super_email").trim();
	String super_mobile = request.getParameter("super_mobile").trim();
	String uaid = request.getParameter("uaid").trim();
	
	boolean isExist=Usermaster_ACT.findUserByMobileOrEmailAndIdNot(super_mobile,super_email,uaid);
	if(isExist) { 
		out.write("exist");
	}else {
		boolean flag=Usermaster_ACT.updateClientSuperUser(super_mobile,token,super_name,super_email,uaid);		
		if(flag)
			out.write("pass");
		else
			out.write("fail");
	}

}catch (Exception e) {
	e.printStackTrace();
}
}

}