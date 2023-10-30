package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ClientUpdateStatus_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String uid = request.getParameter("info").trim();
			String status = request.getParameter("status").trim();
			Clientmaster_ACT.deleteClient(uid,status);

		} catch (Exception e) {
			
		}
	}

}
