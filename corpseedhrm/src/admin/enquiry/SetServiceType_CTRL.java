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
import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class SetServiceType_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();
		
		try {
			HttpSession session = request.getSession(); 
			String token=(String)session.getAttribute("uavalidtokenno");
			String servicetype=request.getParameter("servicetype").trim();
			 String[][] projects=Clientmaster_ACT.getProjects(servicetype,token);
			 for(int i=0;i<projects.length;i++){
				 json.put("prodrefid", projects[i][0]);
				 json.put("pname", projects[i][1]);
//				 System.out.println(projects[i][0]+"/"+projects[i][1]);
				 jsonArr.add(json);
			 }
			 out.println(jsonArr);		
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}