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

import commons.DateUtil;

@SuppressWarnings("serial")
public class SetProductInOrder_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String prodrefid=request.getParameter("prodrefid").trim();
			String servicetype=request.getParameter("servicetype").trim();
			String prodname=request.getParameter("prodname").trim();
			String salesno=request.getParameter("salesno").trim();
			String company=request.getParameter("company").trim();
			String contactrefid=request.getParameter("contactrefid").trim();
			String clientrefid=request.getParameter("clientrefid").trim();
			String statecode="NA";			
			String cstatecode="NA";			
			String key =request.getParameter("esrefid").trim();
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String loginuaid = (String)session.getAttribute("loginuaid");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String productprice[][]=Enquiry_ACT.getProductPriceById(prodrefid,token);			
						
			if(productprice!=null&&productprice.length>0){
				String clientcomp[]=Enquiry_ACT.getClientCompanyDetail(company,token);				
				if(clientcomp[0]!=null&&!clientcomp[0].equalsIgnoreCase("NA")){statecode=clientcomp[0].trim();}
				else if(clientcomp[1]!=null&&!clientcomp[1].equalsIgnoreCase("NA")){statecode=clientcomp[0].substring(0,2);}
				
				String comp[]=Enquiry_ACT.getCompanyDetail(token);
				if(comp[0]!=null&&!comp[0].equalsIgnoreCase("NA")){cstatecode=comp[0].trim();}
				else if(comp[1]!=null&&!comp[1].equalsIgnoreCase("NA")){cstatecode=comp[0].substring(0,2);}
				
				for(int i=0;i<productprice.length;i++){
					if(!productprice[i][1].equalsIgnoreCase("0")) {
					double cgstprice=0;
					double sgstprice=0;
					double igstprice=0;
					double totalprice=0;	
					String pricetype=productprice[i][0];
					double price=Double.parseDouble(productprice[i][1]);
					String hsn=productprice[i][2];
					double cgstpercent=Double.parseDouble(productprice[i][3]);		
					double sgstpercent=Double.parseDouble(productprice[i][5]);
					double igstpercent=Double.parseDouble(productprice[i][6]);
					String key1 =RandomStringUtils.random(40, true, true);
					if(cstatecode.equalsIgnoreCase(statecode)){
						cgstprice=(price*cgstpercent)/100;
						sgstprice=(price*sgstpercent)/100;
						 totalprice=price+cgstprice+sgstprice;
						 igstpercent=0;
					}else{
						igstprice=(price*igstpercent)/100;
						totalprice=price+igstprice;
						cgstpercent=0;
						sgstpercent=0;
					}
					status=Enquiry_ACT.saveSalesProductPrice(salesno,prodrefid,pricetype,price,hsn,cgstpercent,sgstpercent,igstpercent,cgstprice,sgstprice,igstprice,totalprice,key1,token,addedby,key,productprice[i][1]);
					
					if(status){
						json.put("salekey", key);
						json.put("pricetype", pricetype);
						json.put("price", price);
						json.put("hsn", hsn);
						json.put("cgstpercent", cgstpercent);
						json.put("sgstpercent", sgstpercent);
						json.put("igstpercent", igstpercent);
						json.put("taxprice", (cgstprice+sgstprice+igstprice));
						json.put("totalprice", totalprice);
						json.put("pricerefid", key1);
						
						jsonArr.add(json);
					}
					}
				}
				if(status){
					//add default plan ontime
					status=Enquiry_ACT.addDefaultPlanOrder(key,servicetype,prodname,salesno,company,contactrefid,clientrefid,loginuaid,token,addedby,today,"NA","NA",today);
				if(status){
					String milestones[][]=Enquiry_ACT.getProductMilestone(prodrefid, token);
					if(milestones!=null&&milestones.length>0)
						for(int j=0;j<milestones.length;j++){
							String pricePercKey=RandomStringUtils.random(40, true, true); 
							status=Enquiry_ACT.addPricePercentage(pricePercKey,key,milestones[j][7],milestones[j][1],"Full Pay",milestones[j][6],token,addedby,salesno);
						}
				}
				}
				out.println(jsonArr);
			}
			
		}catch (Exception e) {
				e.printStackTrace();
		}

	}
}