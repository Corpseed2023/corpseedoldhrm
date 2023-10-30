package user.logout;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.master.Usermaster_ACT;
import commons.DateUtil;

public class LogoutCtrl extends HttpServlet{

	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(LogoutCtrl.class);
	public void doGet(HttpServletRequest request, HttpServletResponse response)throws IOException,ServletException {
		doPost(request,response);
		log.info("LogoutCtrl Called on "+commons.DateUtil.getCurrentDateIndianFormat()+" at "+DateUtil.getCurrentTime());
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)throws IOException {
		try {
			HttpSession SES = request.getSession();
			String loginuID=(String)SES.getAttribute("loginuID");
			String sessionID=(String)SES.getAttribute("sessionID");
			String uaempid=(String)SES.getAttribute("uaempid");
			String loginuaid=(String)SES.getAttribute("loginuaid");
			//updating logout status
			if(loginuaid!=null)
			Usermaster_ACT.updateUserLoginStatus(loginuaid,2);
			SES.removeAttribute("uavalidtokenno");
			SES.removeAttribute("emproleid");
			SES.removeAttribute("loginuID");
			SES.removeAttribute("empclid");
			SES.removeAttribute("sessionID");
			SES.removeAttribute("loginerrormsg");
			SES.removeAttribute("role");
			SES.removeAttribute("uaempid");
			LoginAction.updateLogoutInformation(loginuID,sessionID);
			LoginAction.updateAttendance(uaempid,DateUtil.getCurrentDateIndianFormat1());
			SES.invalidate();	
			RequestDispatcher rd=request.getRequestDispatcher("/");
			rd.forward(request, response);			
			
		} catch (Exception e) {
			log.info("Exception in LogoutCtrl Class while dispatching Page \n"+e.getMessage());
		}
	}
}
