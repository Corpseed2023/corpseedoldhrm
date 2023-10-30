package employee_master;

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
public class moremployees extends HttpServlet {

	protected void doPost(HttpServletRequest request, HttpServletResponse response)throws ServletException, IOException {

		PrintWriter pw = response.getWriter();
		HttpSession session = request.getSession();

		response.setContentType("application/json");

		int startlimit = Integer.parseInt(request.getParameter("counter"));
		int endlimit = 25;

		String limit = startlimit + "," + endlimit;
		String role=(String)session.getAttribute("emproleid");
		String token=(String)session.getAttribute("uacompany");
		String name= (String)session.getAttribute("name");
		String mobile= (String)session.getAttribute("mobile");
		String email= (String)session.getAttribute("email");
		String from= (String)session.getAttribute("from");
		String to= (String)session.getAttribute("to");

//		String[][] moreemps= Employee_ACT.getAllEmployee(token, limit, name, mobile, email,role);

		JSONArray jsonArr = new JSONArray();
		JSONObject json = new JSONObject();

//		json.put("moreemps", moreemps);

		jsonArr.add(json);
		pw.println(jsonArr);
	}

}
