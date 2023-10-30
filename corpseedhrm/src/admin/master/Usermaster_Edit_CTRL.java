package admin.master;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class Usermaster_Edit_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{  
 boolean status=false;
HttpSession session =request.getSession();

String uid = request.getParameter("uid").trim();
String uaroletype = request.getParameter("uaroletype");
String ualoginid = request.getParameter("userId").trim();
String uapassword = request.getParameter("userPassword").trim();
//String name = request.getParameter("userName");
//String mobile = request.getParameter("userMobile");
//String emailid = request.getParameter("userEmail");
//String uaempid = request.getParameter("userRole");
String department= request.getParameter("department");
String role= request.getParameter("UserRegRole");
String addeduser= request.getParameter("addedbyuser");
String uaaip = request.getRemoteAddr();
String uaabname = request.getHeader("User-Agent");
//String emuid = request.getParameter("emuid");
//String uacompany = request.getParameter("companyname");
String a="";
String access="NA";
if(!uaroletype.equalsIgnoreCase("Client")){
	String uamprivilege[] = request.getParameterValues("privilege");	
for (int i = 0; i < uamprivilege.length; i++) {
	a=a+uamprivilege[i]+"#";
}
access=a.substring(0,a.length()-1);
}

status=Usermaster_ACT.updateUser(uid,ualoginid,uapassword,access,addeduser,uaaip,uaabname,department,role);
if(status)
{
//	session.setAttribute("ErrorMessage", "User is Successfully Updated!.");
	response.sendRedirect(request.getContextPath()+"/managewebuser.html");
}
else {
	session.setAttribute("ErrorMessage", "User is not Updated!.");
	response.sendRedirect(request.getContextPath()+"/notification.html");
}

}catch (Exception e) {
e.printStackTrace();
}
}

}