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

public class moreseo extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1839006548568388334L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String userroll = request.getParameter("userroll").trim();
		String loginuaid = request.getParameter("loginuaid").trim();
		String projectname = request.getParameter("projectname").trim();
		String activitytype = request.getParameter("activitytype").trim();
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");
		String nature = (String) session.getAttribute("nature");
		String keyword = (String) session.getAttribute("keyword");
		String taskname = (String) session.getAttribute("taskname");
		String uacompany=(String)session.getAttribute("uacompany");

		if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
		if(activitytype==null || activitytype.equalsIgnoreCase("null") || activitytype.length() <= 0){ activitytype ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}
		if(nature==null || nature.equalsIgnoreCase("Any") || nature.length() <= 0){ nature ="NA";}
		if(keyword==null || keyword.equalsIgnoreCase("Any") || keyword.length() <= 0){ keyword ="NA";}
		if(taskname==null || taskname.equalsIgnoreCase("Any") || taskname.length() <= 0){ taskname ="NA";}

		String limit = startlimit + "," + endlimit;

		String[][] seo=SeoOnPage_ACT.getAllseo(loginuaid,userroll,"LIMIT "+limit,projectname,activitytype,uacompany, from, to, nature, keyword, taskname);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

		json.put("seo", seo);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}