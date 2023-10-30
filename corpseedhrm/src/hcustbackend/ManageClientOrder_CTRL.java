package hcustbackend;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ManageClientOrder_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		
		String reset="NA";
		reset=request.getParameter("reset");
		if(reset.equalsIgnoreCase("reset")){
			session.removeAttribute("clientfrom");
			session.removeAttribute("clientto");
			session.removeAttribute("include");
			session.removeAttribute("sortby");
			session.removeAttribute("sprjno");
			session.removeAttribute("sprjname");
		}
		RequestDispatcher rd=request.getRequestDispatcher("/client_orders.html");
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
		
		session.setAttribute("clientfrom", clientfrom);
		session.setAttribute("clientto", clientto);
		session.setAttribute("include", include);
		session.setAttribute("sortby", sortby);		
		session.setAttribute("sprjno", sprjno);
		session.setAttribute("sprjname", sprjname);	
	}

}
