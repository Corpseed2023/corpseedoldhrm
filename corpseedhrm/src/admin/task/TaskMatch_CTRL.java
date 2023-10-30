package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class TaskMatch_CTRL extends HttpServlet{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1339834232821567263L;

	public void doPost(HttpServletRequest request,HttpServletResponse response) throws IOException {
		try {
			String tname = request.getParameter("tname").trim();
			String SB =TaskMaster_ACT.checkTName(tname);
			PrintWriter D = response.getWriter();
			D.println(SB);
		}
		catch (Exception s) {
			s.printStackTrace();
		}
	}

}
