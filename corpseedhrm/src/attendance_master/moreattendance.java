package attendance_master;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class moreattendance extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2295571531339134986L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session= request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String EmpID = request.getParameter("EmpID").trim();
		String MonthDate = request.getParameter("MonthDate").trim();
		String from=(String)session.getAttribute("from");
		String to=(String)session.getAttribute("to");
		String uacompany=(String)session.getAttribute("uacompany");

		String limit = startlimit + "," + endlimit;

		if(EmpID==null || EmpID.equalsIgnoreCase("null") || EmpID.length() <= 0){ EmpID ="NA";}
		if(MonthDate==null || MonthDate.equalsIgnoreCase("null") || MonthDate.length() <= 0){ MonthDate ="NA";}
		if(from==null || from.equalsIgnoreCase("null") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("null") || to.length() <= 0){ to ="NA";}

		String[][] atte=Attendance_ACT.getallenqcountersaledata("LIMIT "+limit, EmpID, MonthDate,uacompany, from, to);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

		json.put("atte", atte);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
