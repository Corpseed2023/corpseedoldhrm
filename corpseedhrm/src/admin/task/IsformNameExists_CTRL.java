package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import company_master.CompanyMaster_ACT;

@SuppressWarnings("serial")
public class IsformNameExists_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			
			String formName=request.getParameter("formName").trim();			
			String token=(String)session.getAttribute("uavalidtokenno");
			
			result=CompanyMaster_ACT.isExistFormName(formName,token);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");
			
			
		}

		catch (Exception e) {
			
		}

	}

}