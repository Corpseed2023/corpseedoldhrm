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
public class GetSalesSubPriceList_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			
			String refid=request.getParameter("refid").trim();
//System.out.println("refid=="+refid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String salesprice[][]=Enquiry_ACT.getSalesInvoicePriceList(refid,token);
			String salesType=Enquiry_ACT.findSalesTypeBySalesKey(refid,token);		
				if(salesprice!=null&&salesprice.length>0){
					for(int j=0;j<salesprice.length;j++){
						json.put("prefid", salesprice[j][0]);
						if(salesType.equalsIgnoreCase("1"))
							json.put("pricetype", salesprice[j][1]);
						else
							json.put("pricetype", salesprice[j][1]+" ("+salesprice[j][11].substring(8,10)+" "+DateUtil.getMonthName(salesprice[j][11].substring(5,7))+" "+salesprice[j][11].substring(2,4)+")");
						
						json.put("price", salesprice[j][2]);
						json.put("hsncode", salesprice[j][3]);						
						json.put("cgstpercent", salesprice[j][4]);				
						json.put("sgstpercent", salesprice[j][5]);				
						json.put("igstpercent", salesprice[j][6]);				
						json.put("cgstprice", salesprice[j][7]);				
						json.put("sgstprice", salesprice[j][8]);				
						json.put("igstprice", salesprice[j][9]);				
						json.put("totalprice", salesprice[j][10]);						
						
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