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
public class GetEstimateProductListCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String saleno=request.getParameter("estimateno").trim();

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String estimateprice[][]=Enquiry_ACT.getEstimateProductList(saleno,token);
					
				if(estimateprice.length>0){
					for(int j=0;j<estimateprice.length;j++){		
						String prodrefid[]=Enquiry_ACT.getProductRefId(estimateprice[j][5],estimateprice[j][1],token);
						json.put("esrefid", estimateprice[j][0]);
						if(estimateprice[j][12].equals("1"))
							json.put("prodname", estimateprice[j][1]);		
						else
							json.put("prodname", "Consultation Service");
						
						json.put("prodrefid", prodrefid[0]);	
						json.put("prodtype", estimateprice[j][5]);
						json.put("jurisdiction", estimateprice[j][9]);
						json.put("central", prodrefid[1]);
						json.put("state", prodrefid[2]);
						json.put("global", prodrefid[3]);
						
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