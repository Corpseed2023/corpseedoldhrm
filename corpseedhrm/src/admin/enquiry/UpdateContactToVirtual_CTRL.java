package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class UpdateContactToVirtual_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String contactid=request.getParameter("contactid").trim();
			String colname=request.getParameter("colname").trim();
			String colvalue=request.getParameter("colvalue").trim();
			if(colvalue.length()<=0||colvalue==""||colvalue==null)colvalue="NA";
			String salesid=request.getParameter("salesid").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			
			status=Enquiry_ACT.updateContactDetails(salesid,contactid,colname,colvalue,token);
			
			if(status){
				out.write("pass");
			}else{
				out.write("fail");
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}