package admin.report;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

@SuppressWarnings("serial")
public class GetActivityData extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		
		response.setContentType("application/json");
		
		String pid = request.getParameter("pid").trim();
		String date = request.getParameter("date").trim();
		String date2 = request.getParameter("date2").trim();
		String key = request.getParameter("key").trim();
		
		String[][] getdata= Report_ACT.getActivityData(pid, date, date2, key);
		
		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();
		
		json.put("actdata", getdata);
		
		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
