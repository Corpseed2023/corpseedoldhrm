package admin.report;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class DetailedSearchSeoReport_CTRL extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5936340117188094041L;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		String pid =  null;
		String datefrom = null;
		String dateto = null;
		String month = null;
		String rkkey = null;
		
		String type=request.getParameter("jsstype");
		String pagename=request.getParameter("pageName");
		HttpSession session = request.getSession(true);
		String check=request.getParameter("page_no");
		if(check==null){
			session.setAttribute("pid", pid);
			session.setAttribute("datefrom", datefrom);
			session.setAttribute("dateto", dateto);
			session.setAttribute("month", month);
			session.setAttribute("rkkey", rkkey);
		}else
		{
			pid = (String)session.getAttribute("pid");
            datefrom = (String)session.getAttribute("datefrom");
            dateto = (String)session.getAttribute("dateto");
            month = (String)session.getAttribute("month");
		}
		RequestDispatcher rd = request.getRequestDispatcher("/mreport/detailed-seo-report.jsp");
		rd.forward(request,response);
	}
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String type=request.getParameter("jsstype");
		String pagename=request.getParameter("pageName");
	
		if(type!=null && pagename!=null && type.equalsIgnoreCase("SSEqury") && pagename.equalsIgnoreCase("manageservice.jsp"))
		{		
			String pid = request.getParameter("pid").trim();
			String datefrom = request.getParameter("datefrom").trim();
			String dateto = request.getParameter("dateto").trim();
			String month = request.getParameter("month").trim();
			
			HttpSession session = request.getSession();
			session.setAttribute("pid", pid);
			session.setAttribute("datefrom", datefrom);
			session.setAttribute("dateto", dateto);
			session.setAttribute("month", month);
			
			RequestDispatcher rd = request.getRequestDispatcher("/mreport/detailed-seo-report.jsp");
			rd.forward(request, response);
		}

	}

}
