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
public class morekeywords extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		
		response.setContentType("application/json");
		
		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 30;
		
		String pid = request.getParameter("pid");
		String datefrom = request.getParameter("datefrom");
		
		String limit = startlimit + "," + endlimit;
		
		String[][] getmoredata = Report_ACT.getAllReport(pid, datefrom, limit);
		
		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();
		
		json.put("select", getmoredata);
		
		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
