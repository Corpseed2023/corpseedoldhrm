package admin.task;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


@SuppressWarnings("serial")
public class RemoveProductDocumentRowCTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
				
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String loginuID = (String) session.getAttribute("loginuID");	
		
		    String rowid = request.getParameter("DivId").trim();		
			String prodrefid = request.getParameter("prodrefid").trim();			
			
			TaskMaster_ACT.removeDocumentRow(prodrefid,rowid,uavalidtokenno,loginuID);
			
	}

}