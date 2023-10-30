package admin.report;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AddKeywordInfo_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5400666290400858987L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HttpSession session = request.getSession();

		try {
			String pid = request.getParameter("pid").trim();
			String date = request.getParameter("date").trim();
			String google = request.getParameter("gid").trim();
			String yahoo = request.getParameter("yid").trim();
			String bing = request.getParameter("bid").trim();
			String key = request.getParameter("key").trim();
			String target = request.getParameter("target").trim();
			String addedby = (String)session.getAttribute("loginuID");
			
			if(pid!=null||!pid.equals("null")||!pid.equals(""))
				Report_ACT.updateKeyword(pid,date,google,yahoo,bing,key,target, addedby);

		}

		catch (Exception e) {
			
		}

	}

}
