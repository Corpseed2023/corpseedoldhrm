package admin.seo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class TaskDates_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			HttpSession session=request.getSession();
			String result=null;
			PrintWriter p=response.getWriter();
			String mid=request.getParameter("mid").trim();
			String taskid=request.getParameter("taskid").trim();
			String token=(String)session.getAttribute("uavalidtokenno");
			String loginuaid=(String)session.getAttribute("loginuaid");
			String emproleid=(String)session.getAttribute("emproleid");
			
			result=SeoOnPage_ACT.getDates(mid,taskid,loginuaid,token,emproleid);
			
			p.write(result);
			
		}

		catch (Exception e) {
			e.printStackTrace();
		}

	}

}