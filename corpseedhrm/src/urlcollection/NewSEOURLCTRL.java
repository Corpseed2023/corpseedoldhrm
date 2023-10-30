package urlcollection;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class NewSEOURLCTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5709816761925068005L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session = request.getSession();
		String newsubmiturl = request.getParameter("newsubmiturl").trim();
		String newactivity = request.getParameter("newactivity").trim();
		String newnature = request.getParameter("newnature").trim();
		String newstatus = request.getParameter("newstatus").trim();
		String newlastcheckedon = request.getParameter("newlastcheckedon").trim();
		String newalexa = request.getParameter("newalexa").trim();
		String newda = request.getParameter("newda").trim();
		String newipclass = request.getParameter("newipclass").trim();
		String addedby = (String) session.getAttribute("loginuID");
		String insertstatus = "";
		insertstatus = CollectionACT.insertNewSEOURL(newsubmiturl, newactivity, newnature, newstatus, newlastcheckedon, newalexa, newda, newipclass,addedby);
		pw.write(insertstatus);
	}
}