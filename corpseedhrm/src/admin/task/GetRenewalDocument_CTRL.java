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

public class GetRenewalDocument_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			
			HttpSession session=request.getSession();
			PrintWriter out=response.getWriter();
			String token=(String)session.getAttribute("uavalidtokenno");
			String milestoneuuid=request.getParameter("milestoneuuid");			
			
			String certificates[][]=TaskMaster_ACT.getRenewalCertificates(milestoneuuid,token);
			if(certificates!=null&&certificates.length>0){
				for(int i=0;i<certificates.length;i++){
					json.put("name", certificates[i][0]);				
					
					jsonArr.add(json);
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}