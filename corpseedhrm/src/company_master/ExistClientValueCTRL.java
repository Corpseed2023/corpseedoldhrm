package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class ExistClientValueCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			boolean result=false;
			PrintWriter p=response.getWriter();
			String clientkey=request.getParameter("clientkey").trim();
			String val=request.getParameter("val").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			result=CompanyMaster_ACT.icClientExists(clientkey,val,token);
//			System.out.println("result="+result);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");			
		}catch (Exception e) {
			
		}

	}

}