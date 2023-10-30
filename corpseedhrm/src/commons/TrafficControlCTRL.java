package commons;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.Login.LoginAction;

@SuppressWarnings("serial")
public class TrafficControlCTRL extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String host = request.getParameter("host").trim();
		String referrer = request.getParameter("referrer").trim();
		String useragent = request.getParameter("useragent").trim();
		String userip = request.getRemoteAddr();
		String sessionid = session.getId();

		LoginAction.TrafficControl(host, referrer, useragent, userip, sessionid);

	}

}