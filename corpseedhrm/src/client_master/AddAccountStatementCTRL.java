package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class AddAccountStatementCTRL extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String accountid = request.getParameter("accountid").trim();
		String runnbal = request.getParameter("runnbal").trim();
		String description = request.getParameter("description").trim();
		String date = request.getParameter("date").trim();
		String debit = request.getParameter("debit").trim();
		String credit = request.getParameter("credit").trim();
		String addedby = (String) session.getAttribute("loginuID");
		
		double newrunningbalance = Double.parseDouble(runnbal) - Double.parseDouble(debit) + Double.parseDouble(credit);
		
		Clientmaster_ACT.saveAccountStatement(accountid, description, date, debit, credit, newrunningbalance, addedby);
		
		response.sendRedirect(request.getContextPath()+"/accountstatement.html");
		
	}

}
