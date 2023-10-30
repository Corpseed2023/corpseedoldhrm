package admin.nonseo;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class morenonseo extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2314469772668415507L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 30;

		String loginid = request.getParameter("loginid").trim();
		String userroll = request.getParameter("userroll").trim();
		String pregpname = request.getParameter("pregpname").trim();
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");
		String uacompany=(String)session.getAttribute("uacompany");

		if(pregpname==null || pregpname.equalsIgnoreCase("null") || pregpname.length() <= 0){ pregpname ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

		String[][] nonseo=NonSeo_ACT.getAllNonSeoTask(loginid,userroll,pregpname,limit,uacompany, from, to);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

		json.put("nonseo", nonseo);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}