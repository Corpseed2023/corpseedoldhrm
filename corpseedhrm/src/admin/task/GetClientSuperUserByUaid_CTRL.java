package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import admin.master.Usermaster_ACT;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class GetClientSuperUserByUaid_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
			
			String uaid=request.getParameter("uaid");
			
			String user[][]=Usermaster_ACT.getUserByID(uaid);
			if(user!=null&&user.length>0){
				for(int i=0;i<user.length;i++){
					String name=user[i][5].trim();					
					if(name.contains(" ")) {
						json.put("firstName", name.substring(0,name.indexOf(" ")));					
						json.put("lastName", name.substring(name.indexOf(" "),name.length()));
					}else {
						json.put("firstName", name);	
						json.put("lastName", "");
					}
					
					json.put("email", user[i][7]);				
					json.put("mobile", user[i][6]);
					
					jsonArr.add(json);
				}
				out.print(jsonArr);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}