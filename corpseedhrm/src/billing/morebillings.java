package billing;

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
public class morebillings extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String clientname = request.getParameter("clientname").trim();
		String projectname = request.getParameter("projectname").trim();
		String projecttype = request.getParameter("projecttype").trim();
		String billingtype = request.getParameter("billingtype").trim();
		String status = request.getParameter("status").trim();
		String userroll= (String)session.getAttribute("emproleid");
		String token = (String)session.getAttribute("token");
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");

		if(clientname==null || clientname.equalsIgnoreCase("null") || clientname.length() <= 0){ clientname ="NA";}
		if(projectname==null || projectname.equalsIgnoreCase("null") || projectname.length() <= 0){ projectname ="NA";}
		if(projecttype==null || projecttype.equalsIgnoreCase("null") || projecttype.length() <= 0){ projecttype ="NA";}
		if(billingtype==null || billingtype.equalsIgnoreCase("null") || billingtype.length() <= 0){ billingtype ="NA";}
		if(status==null || status.equalsIgnoreCase("null") || status.length() <= 0){ status ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

//		String[][] billing=Clientmaster_ACT.getAllbill(clientname,limit, token,userroll);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

//		json.put("billing", billing);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
