package client_master;

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
public class moreprojects extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String clientid = request.getParameter("clientid");
		String projectname = request.getParameter("projectname").trim();
		String projecttype = request.getParameter("projecttype").trim();
		String deliverymonth = request.getParameter("deliverymonth").trim();
		String pstatus = request.getParameter("pstatus").trim();
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");
		String userroll= (String)session.getAttribute("emproleid");
		String token=(String)session.getAttribute("token");

		if(clientid==null || clientid.equalsIgnoreCase("null") || clientid.length() <= 0){ clientid ="NA";}
		if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
		if(projecttype==null || projecttype.equalsIgnoreCase("null") || projecttype.length() <= 0){ projecttype ="NA";}
		if(deliverymonth==null || deliverymonth.equalsIgnoreCase("null") || deliverymonth.length() <= 0){ deliverymonth ="NA";}
		if(pstatus==null || pstatus.equalsIgnoreCase("null") || pstatus.length() <= 0){ pstatus ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

//		String[][] project=Clientmaster_ACT.getAllproject("LIMIT "+limit, projectname, projecttype,deliverymonth,pstatus,clientid, token, from, to,userroll);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

//		json.put("project", project);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
