package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import commons.DateUtil;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


@SuppressWarnings("serial")
public class GetSalesTaskNotes_CTRL extends HttpServlet {	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 
		JSONArray jsonArr = new JSONArray();
		JSONObject json=new JSONObject();
		PrintWriter out=response.getWriter();	   
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
		String userRole= (String)session.getAttribute("userRole");
		String userUid=(String)session.getAttribute("loginuaid");
		try{		
		String estKey="NA";
		String salesKey = request.getParameter("salesKey").trim();
		if(salesKey.equalsIgnoreCase("NA"))
			estKey=request.getParameter("estkey");
		
		String notes[][]=TaskMaster_ACT.getAllSalesTaskNotes(salesKey,userRole,uavalidtokenno,userUid,estKey); 
		if(notes!=null&&notes.length>0){
			for(int i=0;i<notes.length;i++){
				json.put("type", notes[i][3]);
				json.put("addedby", notes[i][5]);
				json.put("description", notes[i][8]);				
				json.put("time", DateUtil.getHoursMinutes(notes[i][6]));
				
				jsonArr.add(json);
			}
			out.print(jsonArr);
		}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}