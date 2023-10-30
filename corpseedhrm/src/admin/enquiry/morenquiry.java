package admin.enquiry;

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
public class morenquiry extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session=request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String name = request.getParameter("name").trim();
		String mobile = request.getParameter("mobile").trim();
		String location = request.getParameter("location").trim();
		String status = request.getParameter("status").trim();
		String etype = request.getParameter("etype").trim();
		String token=(String)session.getAttribute("token");
		String userrole=(String)session.getAttribute("emproleid");
		String loginuID=(String)session.getAttribute("loginuID");
		String from = (String) session.getAttribute("from");
		String to = (String) session.getAttribute("to");

		if(name==null || name.equalsIgnoreCase("null") || name.length() <= 0){ name ="NA";}
		if(mobile==null || mobile.equalsIgnoreCase("null") || mobile.length() <= 0){ mobile ="NA";}
		if(location==null || location.equalsIgnoreCase("null") || location.length() <= 0){ location ="NA";}
		if(status==null || status.equalsIgnoreCase("null") || status.length() <= 0){ status ="NA";}
		if(etype==null || etype.equalsIgnoreCase("null") || etype.length() <= 0){ etype ="NA";}
		if(from==null || from.equalsIgnoreCase("Any") || from.length() <= 0){ from ="NA";}
		if(to==null || to.equalsIgnoreCase("Any") || to.length() <= 0){ to ="NA";}

		String limit = startlimit + "," + endlimit;

//		String[][] moreenq=Enquiry_ACT.getAllEnquiry(name, mobile, location, status, etype,"LIMIT "+limit,token,userrole, loginuID, from, to,"NA");

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

//		json.put("moreenq", moreenq);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
