package salary_master;

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
public class moremonsal extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session= request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String emname = request.getParameter("emname").trim();
		String month = request.getParameter("month").trim();
		String from= (String)session.getAttribute("from");
		String to= (String)session.getAttribute("to");
		String uacompany=(String)session.getAttribute("uacompany");

		String limit = startlimit + "," + endlimit;

		if (emname == null || emname.equalsIgnoreCase("null") || emname.length() <= 0) {
			emname = "NA";
		}
		if (month == null || month.equalsIgnoreCase("null") || month.length() <= 0) {
			month = "NA";
		}
		if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}
		String[][] salData=SalaryMon_ACT.getSalaryData(emname, month, limit, uacompany, from, to);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

		json.put("salData", salData);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
