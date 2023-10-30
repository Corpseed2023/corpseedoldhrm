package invoice_master;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GstPaid_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7963708051363045237L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			
			String ghid = request.getParameter("ghid").trim();
			String ghpaidon = request.getParameter("ghpaidon"+ghid).trim();
			String ghremarks = request.getParameter("ghremarks"+ghid).trim();

			GST_ACT.updateGstData(ghid, ghpaidon, ghremarks);

			response.sendRedirect(request.getContextPath() + "/gst-history.html");

		}

		catch (Exception e) {
			
		}

	}

}