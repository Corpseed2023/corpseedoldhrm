package admin.task;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class GetStateCity_CTRL extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			PrintWriter pw=response.getWriter();
			
			String id=request.getParameter("id").trim();
			String fetch=request.getParameter("fetch").trim();
			
			String data="";
			
			if(fetch.equalsIgnoreCase("state")) {
				data="<option value=''>Select State</option>";
				String states[][]=TaskMaster_ACT.getStateByCountryId(id);
				if(states!=null&&states.length>0) {
					for(int i=0;i<states.length;i++) {
						data+="<option value='"+states[i][0]+"#"+states[i][2]+"#"+states[i][1]+"'>"+states[i][1]+"</option>";
					}
				}
				
			}else if(fetch.equalsIgnoreCase("city")) {
				data="<option value=''>Select City</option>";
				String cities[][]=TaskMaster_ACT.getCitiesByStateId(id);
				if(cities!=null&&cities.length>0) {
					for(int i=0;i<cities.length;i++) {
						data+="<option value='"+cities[i][1]+"'>"+cities[i][1]+"</option>";
					}
				}
			}
									
		pw.write(data);
			
		}catch (Exception e) {
			e.printStackTrace();
		}

	}

}