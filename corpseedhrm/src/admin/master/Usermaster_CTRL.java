package admin.master;

import java.net.InetAddress;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import client_master.Clientmaster_ACT;

public class Usermaster_CTRL  extends HttpServlet{

private static final long serialVersionUID = 1L;

public void doPost(HttpServletRequest request,HttpServletResponse response)
{
try
{  
 boolean status=false;
HttpSession session =request.getSession();


String Username = request.getParameter("Username").trim();
String userPassword = request.getParameter("userPassword").trim();
String name = request.getParameter("userName").trim();
String mobile = request.getParameter("User_Mobile").trim();
String emailid = request.getParameter("User_Email").trim();
String uamprivilege[] = request.getParameterValues("privilege");
String addeduser= request.getParameter("addedbyuser").trim();
String uaaip = request.getRemoteAddr();
String uaabname = request.getHeader("User-Agent");
String uaroletype = request.getParameter("uaroletype");
String emuid = request.getParameter("emuid").trim();

String uacompany = request.getParameter("company").trim();
String tokenno = request.getParameter("tokenno").trim();
String key =RandomStringUtils.random(40, true, true);
String a="";
String access="NA";
String department ="NA";
String Role ="NA";
int super_user_uaid=0;
if(!uaroletype.equalsIgnoreCase("Client")){
	department = request.getParameter("department").trim();
	Role = request.getParameter("UserRegRole").trim();
for (int i = 0; i < uamprivilege.length; i++) {
	a=a+uamprivilege[i]+"#";
}
access=a.substring(0,a.length()-1);
}else {
	Role="SUPER_USER";
	super_user_uaid=Clientmaster_ACT.findClientSuperUserIdByClientNo(emuid, tokenno);
}
InetAddress localhost = InetAddress.getLocalHost();
String ipaddress = (localhost.getHostAddress()).trim();

//String access="";
if(emuid!=null&&emuid.length()>0) {	
	status=Usermaster_ACT.saveUserDetail(tokenno,Username,userPassword,name,mobile,emailid,access,addeduser,uaaip,uaabname,uaroletype,emuid, uacompany,key,department,Role,ipaddress,"1",super_user_uaid,0);
}
if(status) {
//	session.setAttribute("ErrorMessage", uaroletype+" is Successfully Created!.");
	response.sendRedirect(request.getContextPath()+"/managewebuser.html");
}else {
	session.setAttribute("ErrorMessage", uaroletype+" is not Created!.");
	response.sendRedirect(request.getContextPath()+"/notification.html");
}

}catch (Exception e) {
	e.printStackTrace();
}
}

}