package hcustbackend;

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
public class GetService_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String name=request.getParameter("name").trim();
			
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String[][] serviceByName = ClientACT.getServiceByName(name,token);
			if(serviceByName!=null&&serviceByName.length>0){
				for(int i=0;i<serviceByName.length;i++){
						json.put("name", serviceByName[i][0]);
						json.put("url", serviceByName[i][1]);
						
						jsonArr.add(json);
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}