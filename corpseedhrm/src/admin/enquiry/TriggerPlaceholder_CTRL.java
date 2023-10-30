package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class TriggerPlaceholder_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
			
			String module=request.getParameter("module").trim();
			
			String placeholders[][]=Enquiry_ACT.getAllPlaceholders(module);
			if(placeholders!=null&&placeholders.length>0){
				for(int i=0;i<placeholders.length;i++){
					
					json.put("id", placeholders[i][0]);
					json.put("value", placeholders[i][1]);
					json.put("description", placeholders[i][2]);
					
					jsonArr.add(json);
					
				}
				out.println(jsonArr);
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}