package admin.seo;

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
public class moretasks extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String projectname = request.getParameter("projectname");
		String date = request.getParameter("date").trim();
		String ddate = request.getParameter("ddate").trim();
		String tname = request.getParameter("tname").trim();
		String userroll = request.getParameter("userroll").trim();
		String loginuaid = request.getParameter("loginuaid").trim();
		String tstatus = request.getParameter("tstatus").trim();
		String token=(String)session.getAttribute("uavalidtokenno");
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");

		if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
		if(date==null || date.equalsIgnoreCase("null") || date.length() <= 0){ date ="NA";}
		if(ddate==null || ddate.equalsIgnoreCase("null") || ddate.length() <= 0){ ddate ="NA";}
		if(tname==null || tname.equalsIgnoreCase("null") || tname.length() <= 0){ tname ="NA";}
		if(tstatus==null || tstatus.equalsIgnoreCase("null") || tstatus.length() <= 0){ tstatus ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

		String[][] task = SeoOnPage_ACT.getAlltask(loginuaid,userroll,"LIMIT "+limit,projectname,date,tname,ddate,tstatus,token, from, to);
		String[][] task1=SeoOnPage_ACT.getAlltask1(loginuaid, userroll,"LIMIT "+limit,projectname,date,tname,ddate,tstatus,token, from, to);
//		String[][] task2=SeoOnPage_ACT.getAlltask2(loginuaid,userroll,"LIMIT "+limit,projectname,date,tname,ddate,tstatus,token, from, to);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

		json.put("taskdata", task);
		json.put("taskdata1", task1);
//		json.put("taskdata2", task2);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
