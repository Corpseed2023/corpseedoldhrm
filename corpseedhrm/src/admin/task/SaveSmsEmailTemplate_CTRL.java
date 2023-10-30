package admin.task;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;

public class SaveSmsEmailTemplate_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 6876401832178092868L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String uaid = (String) session.getAttribute("loginuaid");
		
			
		String templateName = request.getParameter("templateName").trim();	
		String templateSubject = request.getParameter("templateSubject").trim();
		String templateDescription=request.getParameter("templateDescription");
		String type = request.getParameter("type").trim();	
		String today=DateUtil.getCurrentDateIndianFormat1();	
		
		String tKey=RandomStringUtils.random(40,true,true);
		
		boolean flag=TaskMaster_ACT.setTemplate(tKey,today,templateName,templateDescription,type,uaid,uavalidtokenno,templateSubject);		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}