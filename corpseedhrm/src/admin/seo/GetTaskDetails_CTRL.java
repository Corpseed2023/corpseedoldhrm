package admin.seo;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetTaskDetails_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw=response.getWriter();
		try {
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String aid=request.getParameter("aid");
			String result=SeoOnPage_ACT.getTaskDetails(aid,token);
			String getcontent[][] = SeoOnPage_ACT.getContentByTaskID(aid);
			if(getcontent.length>0)
				result+="@"+"Pass";
			else
				result+="@"+"Fail";
			pw.write(result);
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}