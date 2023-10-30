package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsExistEditProductCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			String prodrefid=request.getParameter("prodrefid").trim();
			String servicetype=request.getParameter("servicetype").trim();
			String condcolumn=request.getParameter("condcolumn").trim();
			String val=request.getParameter("val").trim();
			String token=(String)session.getAttribute("uavalidtokenno");  
			result=CompanyMaster_ACT.isExistEditValue(val,condcolumn,prodrefid,token,servicetype);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");
			
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

}