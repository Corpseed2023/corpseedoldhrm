package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsExistSaleHSNCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();			
			String token=(String)session.getAttribute("uavalidtokenno");
			String value=request.getParameter("val");
			result=CompanyMaster_ACT.isExistHSNValue(value,token);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");			
		}

		catch (Exception e) {
			
		}

	}

}