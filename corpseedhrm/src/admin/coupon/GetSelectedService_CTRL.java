package admin.coupon;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

public class GetSelectedService_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
			
			String uuid=request.getParameter("uuid");
			if(uuid!=null)uuid=uuid.trim();
			
			String services[][]=Coupon_ACT.getServicesByProductKey(uuid);
			if(services!=null&&services.length>0){
				for(int i=0;i<services.length;i++){					
					json.put("productNo", services[i][3]);
															
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