package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetEnqStatus_CTRL extends HttpServlet {	

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		try {

			
			HttpSession session = request.getSession(); 
			PrintWriter pw=response.getWriter();
			
			String enquid=request.getParameter("id").trim();			
			String token = (String)session.getAttribute("uavalidtokenno");
			String result = Enquiry_ACT.getEnqStatus(enquid,token);
			
			if(result.equalsIgnoreCase("Final")){
				pw.write("pass");
			}else{
				pw.write("fail");
			}
			
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}

}