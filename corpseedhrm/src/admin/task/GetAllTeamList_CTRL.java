package admin.task;

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
public class GetAllTeamList_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{			
			String[][] teams=TaskMaster_ACT.getAllTeams("Delivery","NA","NA",uavalidtokenno,0,0,"NA","NA");
		if(teams!=null&&teams.length>0){
			for(int i=0;i<teams.length;i++){
				json.put("refid", teams[i][1]);
				json.put("name", teams[i][4]);
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}