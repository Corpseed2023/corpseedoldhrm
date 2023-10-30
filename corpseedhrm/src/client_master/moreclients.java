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
public class moreclients extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String clientname = request.getParameter("clientname").trim();
		String clientmobile = request.getParameter("clientmobile").trim();
		String clientlocation = request.getParameter("clientlocation").trim();
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");
		String uacompany= (String) session.getAttribute("uacompany");

		if(clientname==null || clientname.equalsIgnoreCase("null") || clientname.length() <= 0){ clientname ="NA";}
		if(clientmobile==null || clientmobile.equalsIgnoreCase("null") || clientmobile.length() <= 0){ clientmobile ="NA";}
		if(clientlocation==null || clientlocation.equalsIgnoreCase("null") || clientlocation.length() <= 0){ clientlocation ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

//		String[][] client=Clientmaster_ACT.getAlluser("LIMIT "+limit, clientname, clientmobile,clientlocation, uacompany, from , to);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

//		json.put("client", client);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
