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
public class SetProductPriceList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String esrefid=request.getParameter("pricerefid").trim();
			

			String token = (String)session.getAttribute("uavalidtokenno");
			
			String productprice[][]=Enquiry_ACT.getSalesProductPrice(esrefid,token);
						
			if(productprice.length>0){
				for(int i=0;i<productprice.length;i++){					
						json.put("refid", productprice[i][0]);
						json.put("pricetype", productprice[i][1]);
						json.put("price", productprice[i][2]);
						json.put("hsncode", productprice[i][3]);
						json.put("igstpercent", productprice[i][4]);
						json.put("cgstpercent", productprice[i][9]);
						json.put("sgstpercent", productprice[i][10]);
						json.put("tax", (Double.parseDouble(productprice[i][5])+Double.parseDouble(productprice[i][6])+Double.parseDouble(productprice[i][7])));
						json.put("totalprice", productprice[i][8]);
						json.put("minprice", productprice[i][11]);
						
						jsonArr.add(json);
					
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}