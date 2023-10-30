package company_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class ExistUserValueCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			boolean result=false;
			PrintWriter p=response.getWriter();
			String data=request.getParameter("data").trim();
			String column=request.getParameter("column").trim();
			result=CompanyMaster_ACT.existUserValue(data,column);
//			System.out.println("result="+result);
			if(result) {
				p.write("pass");
			}else
				p.write("fail");			
		}catch (Exception e) {
			
		}

	}

}