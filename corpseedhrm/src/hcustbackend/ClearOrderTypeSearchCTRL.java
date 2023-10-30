package hcustbackend;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ClearOrderTypeSearchCTRL extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			HttpSession session=request.getSession();
			
			String data=request.getParameter("data").trim();
			session.removeAttribute(data);				
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
