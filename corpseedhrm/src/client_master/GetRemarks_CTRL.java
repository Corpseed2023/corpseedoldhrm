package client_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetRemarks_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			String result=null;
			PrintWriter p=response.getWriter();
			String pname=request.getParameter("pname").trim();			
			String token=(String)session.getAttribute("uavalidtokenno");
			result=Clientmaster_ACT.getProductRemarks(pname,token);
			String x[]=result.split("#");
			double price=Clientmaster_ACT.getTotalPrice(x[1], token);
			result+="#"+price;
				p.write(result);	
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

}