package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class isMileStoneDataCorrect_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try
		{
			HttpSession session=request.getSession();
			PrintWriter pw=response.getWriter();
			
			String token=(String)session.getAttribute("uavalidtokenno");	
			String prodKey=request.getParameter("prodKey").trim();
			String result="pass";
			boolean flag=TaskMaster_ACT.isMilestoneExist(prodKey,token);
			if(flag) {
				flag=TaskMaster_ACT.isMilestoneStepExist(prodKey,token);
				result="NoStep";
			}else {
				 result="NoExist";
			}
			
			System.out.println("result="+result);
			pw.write(result);	
		}catch (Exception e) {

		}

	}
}
