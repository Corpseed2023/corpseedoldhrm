package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class IsComplianceExist_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			String result="fail";
			String data = request.getParameter("data").trim();	
			String ckey=request.getParameter("ckey");
			if(ckey==null||ckey=="")ckey="NA";
			
			String token = (String)session.getAttribute("uavalidtokenno");
			
			boolean flag=false;
			if(ckey.equalsIgnoreCase("NA"))		
				flag=Enquiry_ACT.isComplianceExist(data,token);
			else
				flag=Enquiry_ACT.isComplianceExist(ckey,data,token);
			
			if(flag)result="pass";
			
			pw.write(result);
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}
}