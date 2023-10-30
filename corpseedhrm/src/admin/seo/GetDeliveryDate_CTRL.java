package admin.seo;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@SuppressWarnings("serial")
public class GetDeliveryDate_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
			HttpSession session=request.getSession();
			String token=(String)session.getAttribute("uavalidtokenno");
			String result="";
			String pid="";
			String mid="";
			PrintWriter p=response.getWriter();
			try{
				DateFormat df = new SimpleDateFormat("dd-MM-yyyy");
				Calendar calobj = Calendar.getInstance();
				String today = df.format(calobj.getTime());
				pid=request.getParameter("uid");
				mid=request.getParameter("mid");
				String buildingtime=SeoOnPage_ACT.getBuildingTime(pid,mid,token);
				result=SeoOnPage_ACT.getDeliveryDate(today,buildingtime);
				
				p.write(result);
		}

		catch (Exception e) {
			e.printStackTrace();
		}
	}
}