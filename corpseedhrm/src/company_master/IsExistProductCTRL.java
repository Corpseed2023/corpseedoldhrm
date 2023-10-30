package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsExistProductCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			String tokencol=request.getParameter("tokencol").trim();
			String servicecol=request.getParameter("servicecol").trim();
			String servicetype=request.getParameter("servicetype").trim();
			String tablename=request.getParameter("tablename").trim();
			String tableid=request.getParameter("tableid").trim();
			String condcolumn=request.getParameter("condcolumn").trim();
			String val=request.getParameter("val").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			result=CompanyMaster_ACT.isExistValue(tablename,tableid,val,condcolumn,servicecol,servicetype,tokencol,token);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");
			
			
		}

		catch (Exception e) {
			
		}

	}

}