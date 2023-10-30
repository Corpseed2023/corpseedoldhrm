package admin.enquiry;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.RandomStringUtils;

import admin.coupon.Coupon_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;

@SuppressWarnings("serial")
public class AddOnlineOrder_CTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String newtoken=request.getParameter("token").trim();
		String transactionId=request.getParameter("txId");
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
		String token=properties.getProperty("corpseed_token");
		boolean txflag=Enquiry_ACT.isTransactionExist(transactionId,token);
		
		if(!txflag&&token.equals(newtoken)) {
			
			String name=request.getParameter("name");
			if(name!=null)name=name.trim();
			
			String email=request.getParameter("email");
			if(email!=null)email=email.trim();
			
			String mobile=request.getParameter("mobile");
			if(mobile!=null)mobile=mobile.trim();
			
			String city=request.getParameter("city");
			if(city!=null)city=city.trim();
			
			String productNo=request.getParameter("productNo");
			if(productNo!=null)productNo=productNo.trim();
			
			String coupon=request.getParameter("coupon");
			if(coupon!=null)coupon=coupon.trim();
			
			String transactionAmount=request.getParameter("txAmount");
			
			String addedby = properties.getProperty("loginuID");
			String loginuaid =properties.getProperty("loginuaid");
			
			
			boolean status = false; 
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			String start = Usermaster_ACT.getStartingCode(token,"imestimatebillingkey");
			String enquid=Enquiry_ACT.getEstimateEnqUID(token); 
			if (enquid==null||enquid.equalsIgnoreCase("0") || enquid.equalsIgnoreCase("")) {
				enquid=start+"1";
			}
			else {
				   String enq=enquid.substring(start.length());
				   int j=Integer.parseInt(enq)+1;
			 	   enquid=start+Integer.toString(j);
				}	
			
			String salesid =enquid;			
			String comp_name = "....";
			String clientrefid="NA";
			
			if(email!=null&&email.length()>0) {				
				String client[]=Clientmaster_ACT.getClientDetailsByEmail(email,token);
				if(client[0]!=null&&client[1]!=null) {
					clientrefid=client[0];
					comp_name=client[1];
//					System.out.println(clientrefid+"/"+comp_name);
				}
			}
			
			String remarks="Online order from www.corpseed.com";
			String contactrefid =RandomStringUtils.random(40, true, true);		
			
			
			String prodrefid=Enquiry_ACT.getProductKeyByNo(productNo,token);
			
				//creating sales id
				String newsalesid=Enquiry_ACT.getEstimateEnqUID(token);
				String initial = Usermaster_ACT.getStartingCode(token,"imestimatebillingkey");
				if (newsalesid==null||newsalesid.equalsIgnoreCase("0") || newsalesid.equalsIgnoreCase("")) {
					newsalesid=initial+"1";
				}else {
					   String enq=newsalesid.substring(initial.length());
					   int j=Integer.parseInt(enq)+1;
					   newsalesid=initial+Integer.toString(j);
					}
				
				//creating sales ref key
				String key =RandomStringUtils.random(40, true, true);
				//getting hsn code whose have 9% sgst and 9%Cgst
				String hsnCode=TaskMaster_ACT.getHsnCode(token);
				//getting products price detaills and adding to final sales price table
				String[][] product=Enquiry_ACT.getProductPriceList(prodrefid,token);
				if(product!=null&&product.length>0){
					for(int j=0;j<product.length;j++){
						int qty=1;
						String hsn=hsnCode;
						double cgstprice=0;
						double sgstprice=0;
						double igstprice=0;
						double totalprice=0;						
						double cgst=9;
						double sgst=9;
						double igst=0;
						double price=Double.parseDouble(product[j][2])*qty;
					
						cgstprice=(price*cgst)/100;
						sgstprice=(price*sgst)/100;
						totalprice=price+cgstprice+sgstprice;
						igst=0;
						
						String priceKey=RandomStringUtils.random(40,true,true);
						Enquiry_ACT.saveSalesProductPrice(newsalesid,prodrefid,product[j][3],price,hsn,cgst,sgst,igst,cgstprice,sgstprice,igstprice,totalprice,priceKey,token,addedby,key,product[j][2]);
					}
				}
					//getting product type and product name
					String productdetails[]=Enquiry_ACT.getSalesProductType(prodrefid, token);
				
					//getting coupon and apply again discount
					double orderAmount=0;
					double discount=0;
					String value="0";
					String couponType="NA";
					String today1=DateUtil.getCurrentDateIndianReverseFormat();
					if(coupon!=null&&coupon.length()>0&&!coupon.equalsIgnoreCase("NA")) {
						String couponData[][]=Coupon_ACT.getCouponByTitle(coupon,today1,token);
						if(couponData!=null&&couponData.length>0) {
							couponType=couponData[0][4];
							coupon=couponData[0][2];
							value=couponData[0][3];
//							System.out.println(couponType+"/"+coupon);
//							
							double serviceAmount=Enquiry_ACT.getOrderAmount(salesid, token);
//							System.out.println("serviceAmount=="+serviceAmount);
							if(couponData[0][13].equals("selected")) {
								String productNumber=TaskMaster_ACT.getProductNo(prodrefid, token);
								boolean flag=Coupon_ACT.isCouponServiceExist(productNumber, couponData[0][1]);
								if(flag) {
									orderAmount=serviceAmount;
								}
							}else if(couponData[0][13].equals("all")){
								orderAmount=serviceAmount;
							}
												
							if(orderAmount>0&&couponData[0][4].equals("percentage")) {
								discount=(orderAmount*Double.parseDouble(couponData[0][3]))/100;
								//check max discount
								double maxDiscount=Double.parseDouble(couponData[0][11]);
								if(discount>maxDiscount)discount=maxDiscount;
							}else if(orderAmount>0&&couponData[0][4].equals("fixed")){
								discount=Double.parseDouble(couponData[0][3]);
							}
//						System.out.println(orderAmount+"/"+discount);
						}
					}else {
						coupon="NA";
					}
					status = Enquiry_ACT.AddEstimateSale(newsalesid, productdetails[0], comp_name,remarks,addedby,
							token,productdetails[1],key,today,loginuaid,contactrefid,clientrefid,"OneTime","NA","NA",
							"1",coupon,couponType,discount,value,loginuaid,"NA","Online","NA","NA",
							Integer.parseInt(productdetails[3]),productdetails[4],"1");
					if(status){
						String milestones[][]=Enquiry_ACT.getProductMilestone(prodrefid, token);
						if(milestones!=null&&milestones.length>0)
							for(int j=0;j<milestones.length;j++){
								String pricePercKey=RandomStringUtils.random(40, true, true); 
								status=Enquiry_ACT.addPricePercentage(pricePercKey,key,milestones[j][7],milestones[j][1],"Full Pay",milestones[j][6],token,addedby,newsalesid);
							}
					}
					
				String contactKey="NA";
				//saving company details String 
				contactKey=Clientmaster_ACT.getContactByEmail(email,mobile,token);
				if(contactKey==null||contactKey.equals("NA")) {
					contactKey=RandomStringUtils.random(40,true,true);
					status=Clientmaster_ACT.saveContactDetail(clientrefid,contactKey,comp_name,name.substring(0,name.indexOf(" ")),name.substring(name.indexOf(" ")),email,"NA","NA",mobile,city,"NA","Personal","NA",addedby,token,"2","NA","NA","NA",0);
				}
				//saving contact data in both table					
				Enquiry_ACT.saveSalesContact(contactrefid,name,email,"NA",mobile,"NA",contactKey,token,addedby,0);
				
			if(status) {
				//adding estimate notification
				String estremarks="Estimate invoice created";
				String estKey=RandomStringUtils.random(40,true,true);
				Clientmaster_ACT.saveEstimateNotification(estKey,newsalesid,loginuaid,estremarks,today,token);
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String message="Estimate no. : "+salesid+" is created by &nbsp;<span class='text-muted'>"+name+"</span>";			
				TaskMaster_ACT.addNotification(nKey,today,loginuaid,"2","manage-estimate.html",message,token,loginuaid,"fas fa-receipt");
				String productName=TaskMaster_ACT.getProductName(prodrefid, token);
				//add payment into virtual order
				String key2 =RandomStringUtils.random(40, true, true);
				
				int min = 100;  
				int max = 999;  
				int random = (int)(Math.random()*(max-min+1)+min);  
				String pinvoice="INV"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
				boolean invoice_flag=true;
				while(invoice_flag) {
					invoice_flag=Enquiry_ACT.isPaymentInvoiceExist(pinvoice, token);
					if(invoice_flag)
						pinvoice="INV"+today.replaceAll("-", "").substring(0,4)+today.substring(today.length()-2)+random;
				}
				
				status=Enquiry_ACT.uploadSalesProductPayment(key2,"Online",today,transactionId,transactionAmount,salesid,"NA","NA",token,addedby,"NA",productName,pinvoice,"Online","NA",1);
				if(status){			
					
					String billrefid =RandomStringUtils.random(40, true, true);
					double orderamt=Enquiry_ACT.getOrderAmount(salesid, token);
					double paidamt=Enquiry_ACT.getPaidAmount(salesid, token);						
//					System.out.println("orderamt=="+orderamt+"/disc=="+discount);
					orderamt-=discount;
					double dueamt=orderamt-paidamt;
//					System.out.println("due==="+dueamt);
					String couponApply[]=Enquiry_ACT.getAppliedCoupon(salesid,token);
					status=Enquiry_ACT.addPaymentDetails(billrefid,today,salesid,comp_name,clientrefid,contactrefid,transactionAmount,orderamt,paidamt,dueamt,token,couponApply[0],couponApply[1],couponApply[2],discount);
					
					//adding notification
					String nKey1=RandomStringUtils.random(40,true,true);
					String showUaid=Enquiry_ACT.getEstimateSalesSoldByUaid(salesid,token);
					String message1="Payment of rs. "+transactionAmount+" is registered against estimate no. :"+salesid+" for approval by &nbsp;<span class='text-muted'>"+name+"</span>";
					TaskMaster_ACT.addNotification(nKey1,today,showUaid,"2","manage-estimate.html",message1,token,loginuaid,"fas fa-rupee-sign");
					
				}				
			}
			if(status)response.setStatus(200);
		}else {
			response.setStatus(400);
		}

	}
}