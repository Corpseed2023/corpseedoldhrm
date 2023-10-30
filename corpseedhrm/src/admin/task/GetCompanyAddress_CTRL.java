package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import client_master.Clientmaster_ACT;

public class GetCompanyAddress_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			String clientKey=request.getParameter("clientKey").trim();
			
			String data[]=Clientmaster_ACT.getClientAddressByRefid(clientKey, token);
									
			pw.write(data[0]);
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}