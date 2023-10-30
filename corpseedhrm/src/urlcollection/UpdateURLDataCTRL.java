package urlcollection;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateURLDataCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -3285740194123390351L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String id = request.getParameter("id").trim();
		String submiturl = request.getParameter("submiturl").trim();
		String activity = request.getParameter("activity").trim();
		String nature = request.getParameter("nature").trim();
		String status = request.getParameter("status").trim();
		String alexa = request.getParameter("alexa").trim();
		String da = request.getParameter("da").trim();
		String ipclass = request.getParameter("ipclass").trim();

		CollectionACT.updateURLData(id, submiturl, activity, nature, status, alexa, da, ipclass);

	}

}
