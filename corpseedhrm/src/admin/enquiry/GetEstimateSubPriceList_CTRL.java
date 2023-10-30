package admin.enquiry;

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
public class GetEstimateSubPriceList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String refid=request.getParameter("refid");
			if(refid!=null) {
			String token = (String)session.getAttribute("uavalidtokenno");
			String salesType=Enquiry_ACT.findSalesTypeByKey(refid,token);
			String estimateprice[][]=Enquiry_ACT.getEstimatePriceList(refid,token);
					
				if(estimateprice!=null&&estimateprice.length>0){
					for(int j=0;j<estimateprice.length;j++){
						json.put("prefid", estimateprice[j][0]);
						if(salesType.equalsIgnoreCase("1"))
							json.put("pricetype", estimateprice[j][1]);
						else
							json.put("pricetype", estimateprice[j][1]+" ("+estimateprice[j][11].substring(8,10)+" "+DateUtil.getMonthName(estimateprice[j][11].substring(5,7))+" "+estimateprice[j][11].substring(2,4)+")");
						
						json.put("price", estimateprice[j][2]);
						json.put("hsncode", estimateprice[j][3]);						
						json.put("cgstpercent", estimateprice[j][4]);				
						json.put("sgstpercent", estimateprice[j][5]);				
						json.put("igstpercent", estimateprice[j][6]);				
						json.put("cgstprice", estimateprice[j][7]);				
						json.put("sgstprice", estimateprice[j][8]);				
						json.put("igstprice", estimateprice[j][9]);				
						json.put("totalprice", estimateprice[j][10]);						
						
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}
			}		
		}
		catch (Exception e) {
				e.printStackTrace();
		}

	}
}