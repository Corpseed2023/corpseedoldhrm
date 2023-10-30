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

@SuppressWarnings("serial")
public class GetEstimateSalesProduct_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String saleno=request.getParameter("saleno").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			String estimateProduct[][]=Enquiry_ACT.getEstimateProduct(saleno,token);
					
				if(estimateProduct!=null&&estimateProduct.length>0){
					for(int j=0;j<estimateProduct.length;j++){
						
						if(estimateProduct[j][1].equals("1"))
							json.put("name", estimateProduct[j][0]);	
						else
							json.put("name", "Consultation Service");
						
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