package hcustbackend;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageClientInbox_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		
		String reset="NA";
		reset=request.getParameter("reset");
		if(reset.equalsIgnoreCase("reset")){
			session.removeAttribute("clientinboxfrom");
			session.removeAttribute("clientinboxto");
			session.removeAttribute("includeinbox");
			session.removeAttribute("sortbyinbox");
			session.removeAttribute("sprjnoinbox");
			session.removeAttribute("sprjnameinbox");
		}
		RequestDispatcher rd=request.getRequestDispatcher("/client_inbox.html");
		rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		
		String clientfrom=request.getParameter("clientfrom");	
		String clientto=request.getParameter("clientto");
		String include=request.getParameter("include");
		String sortby=request.getParameter("sortby");
		String sprjno=request.getParameter("sprjno");
		String sprjname=request.getParameter("sprjname");
		System.out.println(clientfrom+"/"+clientto);
		session.setAttribute("clientinboxfrom", clientfrom);
		session.setAttribute("clientinboxto", clientto);
		session.setAttribute("includeinbox", include);
		session.setAttribute("sortbyinbox", sortby);		
		session.setAttribute("sprjnoinbox", sprjno);
		session.setAttribute("sprjnameinbox", sprjname);	
	}

}
