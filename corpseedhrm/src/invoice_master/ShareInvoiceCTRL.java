package invoice_master;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class ShareInvoiceCTRL extends HttpServlet {

	private static final long serialVersionUID = -5858049879213657309L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
		RequestDispatcher RD = request.getRequestDispatcher("receipt/invoice_new.jsp");
		RD.forward(request, response);
	}
}
