package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ExistEditValueCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			String field=request.getParameter("field").trim();
			String val=request.getParameter("val").trim();
			String id=request.getParameter("id").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			result=CompanyMaster_ACT.existEditValue(field,val,id,token);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");
			
			
		}

		catch (Exception e) {System.out.println(e);
			
		}

	}

}