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

public class SaveDynamicFormTemplate_CTRL extends HttpServlet {	
	
	private static final long serialVersionUID = 6876401832178092868L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String uaid = (String) session.getAttribute("loginuaid");
		
			
		String dynamicFormName = request.getParameter("dynamicFormName").trim();	
		String formDataJson = request.getParameter("formDataJson").trim();	
		String type = request.getParameter("type").trim();	
		String today=DateUtil.getCurrentDateIndianFormat1();	
		
		String tKey=RandomStringUtils.random(40,true,true);
		
		boolean flag=TaskMaster_ACT.setTemplate(tKey,today,dynamicFormName,formDataJson,type,uaid,uavalidtokenno,"NA");		
		if(flag) {
			pw.write("pass");
		}else {
			pw.write("fail");
		}
	}

}