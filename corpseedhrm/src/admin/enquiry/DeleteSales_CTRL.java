package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class DeleteSales_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			PrintWriter pw=response.getWriter();
			
			String srefid=request.getParameter("srefid").trim();
			boolean flag=Enquiry_ACT.deleteSalesPayment(srefid);
			
			if(flag){
				pw.write("pass");
			}else{pw.write("fail");}
		}
		catch (Exception e) {

		}

	}
}