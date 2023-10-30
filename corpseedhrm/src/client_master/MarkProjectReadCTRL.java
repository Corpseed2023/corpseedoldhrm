package client_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class MarkProjectReadCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6456141965340467867L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String uid = request.getParameter("uid").trim();
		Clientmaster_ACT.markProjectRead(uid);

	}

}
