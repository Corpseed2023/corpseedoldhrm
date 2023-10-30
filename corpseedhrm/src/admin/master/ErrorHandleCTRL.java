package admin.master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class ErrorHandleCTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		PrintWriter out = response.getWriter();
		Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
		out.write("<html>");
		out.write("<head>");
		out.write("</head>");
		out.write("<body>");
		out.println("<p>Error " + statusCode + " occured!! Click here to go back to the ");
		out.println("<a href="+request.getContextPath()+"/>Home Page</a></p><p>");
		switch (statusCode) {
		case 403:
			out.println("Error 403: You don't have the permissions to access this page!");
			break;
		case 404:
			out.println("Error 404: This page does not exists! Please check the URL..");
			break;
		case 500:
			out.println("Error 500: Server Error Occured! Please try again..");
			break;
		case 503:
			out.println("Error 503: Server Unavailable! Please try again later..");
			break;
		default:
			out.println("Some Error Occured!");
			break;
		}
		out.println("</p>");
		out.write("</body>");
		out.write("</html>");

	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}
}