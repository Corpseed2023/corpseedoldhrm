package admin.Login;

import java.io.IOException;
import java.net.InetAddress;
//import java.net.NetworkInterface;
//import java.util.Collections;
//import java.util.Enumeration;
import java.util.Properties;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class LoginCtrl extends HttpServlet {

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(LoginCtrl.class);

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException,ServletException {
		log.info("LoginCtrl Called on "+commons.DateUtil.getCurrentDateIndianFormat()+" at "+DateUtil.getCurrentTime());
		String loginuID = request.getParameter("userId");
		String password = request.getParameter("userPassword");
//		System.out.println(loginuID+"\n"+password);
		if(loginuID!=null&&password!=null)
			doPost(request, response);
				
		RequestDispatcher rd=request.getRequestDispatcher("/");
		rd.forward(request, response);
	}

	@SuppressWarnings("static-access")
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String domain=properties.getProperty("domain");
		
		boolean status = false;
		boolean isvaliduser = false;
//		boolean isDateUpdated = false;
		boolean ipAllow=false;

		String destination = "";
		String emproleid = "";
		String userRole = "";
		String loginuaid = "";
		String loginuarefid = "";
		String uaname = "";
		String uaempid = "";
//		String token = "";
		String uacompany = "";
		String department = "";
		String uavalidtokenno="";
		String uarefid="";

		HttpSession session = request.getSession();
		RequestDispatcher disp = null;

		String loginuID = request.getParameter("userId");
		String password = request.getParameter("userPassword");

					
		InetAddress localhost = InetAddress.getLocalHost();
		String ipaddress = (localhost.getHostAddress()).trim();
		String remotehostname = request.getParameter("empbrowser");
		
		ipAllow = LoginAction.isIpAllowedForAccess(loginuID, request);
		  ipAllow = LoginAction.isIpAllowedForAccess(loginuID, request);


		    if (!ipAllow && !emproleid.equalsIgnoreCase("super admin")) {
		        // If IP is not allowed and the user is not a super admin, deny access
		        request.setAttribute("loginerrormsg", "Access Denied: Your IP is not allowed.");
		        destination = "/403.html";  
		        disp = request.getRequestDispatcher(destination);
		        disp.forward(request, response);
		        return; 
		    }
		
      System.out.println("Ip test =="+ipAllow);


		LoginAction loAction = new LoginAction();

		try {		
								
			log.info("User "+loginuID+" tried Log in on "+DateUtil.getCurrentDateIndianFormat()+" at "+DateUtil.getCurrentTime());

			response.setHeader("Cache-Control", "must-revalidate");

			if(loginuID!=null && password!=null) {
				isvaliduser=loAction.isValidUser(loginuID, password);
			}			

			if(isvaliduser) {
				uavalidtokenno = loAction.getEmptokenid(loginuID);
				loginuaid = loAction.getEmpCID(loginuID);
				
				emproleid = loAction.getRoleType(loginuID);
				department = loAction.getDepartment(loginuID);
				
				ipAllow=loAction.isIpAllow(ipaddress,loginuaid);
				if(ipAllow||emproleid.equalsIgnoreCase("super admin")) {
				
				loginuarefid = loAction.getLoginRefid(loginuID);
				uarefid=loAction.getUserRefid(loginuID);
				
				String sessionID=session.getId();
				
				userRole = loAction.getRole(loginuID);
				uacompany=loAction.getCompany(loginuID);

					uaname = loAction.getEmpName(loginuID);
					uaempid = loAction.getEmpId(loginuID);

					session.setAttribute("loginuarefid", loginuarefid);
					session.setAttribute("sessionID", sessionID);
					session.setAttribute("uavalidtokenno", uavalidtokenno);
					session.setAttribute("emproleid", emproleid);
					session.setAttribute("userRole", userRole);
					session.setAttribute("loginuID", loginuID);
					session.setAttribute("uaname", uaname);
					session.setAttribute("loginuaid", loginuaid);
					session.setAttribute("uaempid", uaempid);
					session.setAttribute("uacompany", uacompany);
					session.setAttribute("uadepartment", department);
					loAction.storeLoginInformation(loginuID, sessionID, ipaddress, remotehostname,uavalidtokenno);
					loAction.updateUAwithSession(loginuID, sessionID,ipaddress);
					
					status = true;
				}
//				System.out.println("Going to update login status............");
				//updating login status
				if(loginuaid!=null)
				Usermaster_ACT.updateUserLoginStatus(loginuaid,1);
//				System.out.println("Login status updated----"+Usermaster_ACT.getLoginStatus(loginuaid));
				
				}else {
					session.setAttribute("loginerrormsg", "Either Username or password is wrong !!");
					destination = "/";
				}
//System.out.println("status=="+status+"# valif=="+isvaliduser);
			if (status) {
				if (emproleid.equalsIgnoreCase("Client")) {
					destination = "/client_dashboard.html";
					String clname=loAction.getClientName(loginuID);					
					String cluaempid = loAction.getEmpId(loginuID);
//					String clintUaid=ClientACT.getClientId(cluaempid, uavalidtokenno);
					session.setAttribute("loginclname", clname);
//					session.setAttribute("loginClintUaid", clintUaid);
					session.setAttribute("cluaempid", cluaempid);
					
				} else {
					log.info("User " + loginuID + " Logged in on " + DateUtil.getCurrentDateIndianFormat() + " at " + DateUtil.getCurrentTime());
					loAction.addAttendance(uaempid, loginuID,uavalidtokenno);
					destination = "/dashboard.html";
				}
			}else if (!isvaliduser&&ipAllow) {
				log.info("User " + loginuID + " Try to Login (But User/Password incorrect) at " + DateUtil.getCurrentDateIndianFormat() + " at " + DateUtil.getCurrentTime());
				request.setAttribute("loginerrormsg", "Invalid Username or Password. Please relogin.");
				destination = "/";
			}
			
			if(!ipAllow&&!emproleid.equalsIgnoreCase("super admin")&&!destination.equalsIgnoreCase("/"))destination = "/403.html";

			String forwardUrl=request.getParameter("forwardUrl");
				
			if (forwardUrl!=null&&!forwardUrl.equals(domain)&&!forwardUrl.equals((domain+"login.html"))&&emproleid.equalsIgnoreCase("Client")&&forwardUrl.contains("client")) {	
				disp = request.getRequestDispatcher(forwardUrl.substring(domain.length()));
			}else { 
				disp = request.getRequestDispatcher(destination);			
			}
//			System.out.println("forward url=="+forwardUrl+"//"+isvaliduser);
			
			disp.forward(request, response);
			
		} catch (Exception s) {
			s.printStackTrace();
			log.info("Servlet Exception in LoginCtrl Class while dispatching Page \n"+s.getMessage());
		}
	}
}
	
