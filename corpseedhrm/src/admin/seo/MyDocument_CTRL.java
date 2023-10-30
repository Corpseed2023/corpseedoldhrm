package admin.seo;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class MyDocument_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//		RequestDispatcher rd = null;
//		HttpSession session = request.getSession();
//		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
//		String uaIsValid = (String) session.getAttribute("loginuID");
//		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
//			rd = request.getRequestDispatcher("/login.html");
//			rd.forward(request, response);
//		}		
		RequestDispatcher RD = request.getRequestDispatcher("mseo/my-document.jsp");
		RD.forward(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//		RequestDispatcher rd = null;
		HttpSession session = request.getSession();
//		String uavalidtokenno111 = (String) session.getAttribute("uavalidtokenno");
//		String uaIsValid = (String) session.getAttribute("loginuID");
//		if (uaIsValid == null || uaIsValid.equals("") || uavalidtokenno111 == null || uavalidtokenno111.equals("")) {
//			rd = request.getRequestDispatcher("/login.html");
//			rd.forward(request, response);
//		}	
		
		if (request.getParameter("button").equalsIgnoreCase("Search")){
			
			String clientname = request.getParameter("clientname").trim();
			String clientid = request.getParameter("clientid").trim();
			String foldername = request.getParameter("foldername").trim();
			String projectno = request.getParameter("projectno").trim();		
//			System.out.println("clientnameclientname="+clientname);
			
			session.setAttribute("mdclientname", clientname);
			session.setAttribute("mdclientid", clientid);
			session.setAttribute("mdfoldername", foldername);
			session.setAttribute("mdprojectno", projectno);
			
		}else if (request.getParameter("button").equalsIgnoreCase("Reset")){
			session.removeAttribute("mdclientname");
			session.removeAttribute("mdclientid");
			session.removeAttribute("mdfoldername");
			session.removeAttribute("mdprojectno");
		}
			RequestDispatcher RD = request.getRequestDispatcher("mseo/my-document.jsp");
			RD.forward(request, response);
		}


}