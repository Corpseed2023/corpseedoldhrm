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

import org.apache.commons.lang.RandomStringUtils;

import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;

@SuppressWarnings("serial")
public class SetProductInVirtual_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String prodrefid=request.getParameter("prodrefid").trim();
			String salesid=request.getParameter("salesid").trim();
			String compKey=request.getParameter("compKey");
			String key =RandomStringUtils.random(40, true, true);
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String country=Clientmaster_ACT.getClientCountryByKey(compKey,token);
			
			String productprice[][]=Enquiry_ACT.getProductPriceById(prodrefid,token);
			int prodno=Enquiry_ACT.getProductNumber(salesid,token);
			prodno++;
			
			//add default plan ontime
			status=Enquiry_ACT.addDefaultPlan(key,token,addedby);
			
			String global=TaskMaster_ACT.getProductJurisdictionStatus(prodrefid, token,"pglobal");
			String central=TaskMaster_ACT.getProductJurisdictionStatus(prodrefid, token,"pcentral");
			String state=TaskMaster_ACT.getProductJurisdictionStatus(prodrefid, token,"pstate");
			
			if(productprice.length>0){
				for(int i=0;i<productprice.length;i++){
					String pricetype=productprice[i][0];
					String price=productprice[i][1];
					String hsn=productprice[i][2];
					String cgst=productprice[i][3];
					String total_price=productprice[i][4];
					String sgst=productprice[i][5];
					String igst=productprice[i][6];
					String key1 =RandomStringUtils.random(40, true, true);
					if(!country.equalsIgnoreCase("India")&&!country.equals("NA")) {
						hsn="NA";cgst=sgst=igst="0";
					}
					
					status=Enquiry_ACT.addPriceInCart(key,salesid,prodno,prodrefid,pricetype,price,hsn,cgst,sgst,igst,total_price,key1,token,addedby);
									
					
					if(status){
						json.put("groupkey", key);
						json.put("prodrefid", prodrefid);
						json.put("pricetype", pricetype);
						json.put("price", price);
						json.put("hsn", hsn);
						json.put("igst", igst);
						json.put("total_price", total_price);
						json.put("vrefid", key1);
						json.put("prodno", prodno);
						json.put("global", global);
						json.put("central", central);
						json.put("state", state);
						json.put("country", country);
						
						jsonArr.add(json);
					}
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}