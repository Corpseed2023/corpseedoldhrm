package daily_expenses;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class moredailyexp extends HttpServlet {
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session= request.getSession();
		
		response.setContentType("application/json");
		
		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;
		
		String date = request.getParameter("date");
		String month = request.getParameter("month");
		String uacompany=(String)session.getAttribute("uacompany");
		String to = (String) session.getAttribute("to");
		String gst = (String) session.getAttribute("gst");
		
		String limit = startlimit + "," + endlimit;
		
		if(date==null || date.equalsIgnoreCase("null") || date.length() <= 0){ date ="NA";}
		if(month==null || month.equalsIgnoreCase("null") || month.length() <= 0){ month ="NA";}
		
		String[][] dailyexp=Daily_Expenses_ACT.getallExpensesdata(date,month,"LIMIT "+limit, uacompany, to, gst);
		
		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();
		
		json.put("dailyexp", dailyexp);
		
		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
