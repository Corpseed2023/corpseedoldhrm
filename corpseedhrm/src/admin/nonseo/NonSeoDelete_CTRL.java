package admin.nonseo;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class NonSeoDelete_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 8262391932849314743L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String uid = request.getParameter("info").trim();
			NonSeo_ACT.nonSeoTaskDelete(uid);

		} catch (Exception e) {
			
		}

	}
}
