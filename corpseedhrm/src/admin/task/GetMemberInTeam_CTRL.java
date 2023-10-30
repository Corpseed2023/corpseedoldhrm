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
public class GetMemberInTeam_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		try{		
		String teamrefid = request.getParameter("teamrefid").trim();
		String member[][]=TaskMaster_ACT.getAllTeamMemberByRefid(teamrefid,uavalidtokenno);
		if(member!=null&&member.length>0){
			for(int i=0;i<member.length;i++){
				json.put("tmid", member[i][0]);
				json.put("tmrefid", member[i][1]);
				json.put("tmdate", member[i][2]);
				json.put("tmusercode", member[i][3]);
				json.put("tmuseruid", member[i][4]);
				json.put("tmusername", member[i][5]);
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}