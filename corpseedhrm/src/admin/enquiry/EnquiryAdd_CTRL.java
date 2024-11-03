package admin.enquiry;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import admin.coupon.Coupon_ACT;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;

public class EnquiryAdd_CTRL extends HttpServlet {

	private static final long serialVersionUID = 8387178096181326861L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			boolean status = false;
			HttpSession session = request.getSession(); 
			String today=DateUtil.getCurrentDateIndianFormat1();
			
			String salesid = request.getParameter("salesid").trim();			
			String comp_name = request.getParameter("Company_Name").trim();
			String clientrefid = request.getParameter("compuniquecregrefid").trim();
			String soldBySale = request.getParameter("leadsoldby").trim();
			int enq_super_user=Integer.parseInt(request.getParameter("enq_super_user").trim());
			String notes=request.getParameter("notes").trim();
			String orderNo=request.getParameter("orderNo").trim();
			String purchaseDate=request.getParameter("purchaseDate").trim();
			if(orderNo==null||orderNo.length()<=0)orderNo="NA";
			if(purchaseDate==null||purchaseDate.length()<=0)purchaseDate="NA";
			String statecode="NA";	 		
			String cstatecode="NA";			
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String loginuaid = (String)session.getAttribute("loginuaid");
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String domain=properties.getProperty("domain");
			
			String salesType=request.getParameter("saleType").trim();			
			
			synchronized (this) {		
				
				//getting all contact related to this sales
				String contact[][]=Enquiry_ACT.getSalesContactList(salesid,token,addedby);
				if(contact!=null&&contact.length>0) {
					String contactrefid =RandomStringUtils.random(40, true, true);	
					String contactEmail="NA";
					//saving contact data
					if(contact!=null&&contact.length>0){
						contactEmail=contact[0][1];
						for(int i=0;i<contact.length;i++){
	//						System.out.println(contactrefid+","+contact[i][0]+","+contact[i][1]+","+contact[i][2]+","+contact[i][3]+","+contact[i][4]+","+contact[i][5]+","+token+","+addedby);
							Enquiry_ACT.saveSalesContact(contactrefid,contact[i][0],contact[i][1],contact[i][2],contact[i][3],contact[i][4],contact[i][5],token,addedby,enq_super_user);
						}
						
					}
								
				
				if(comp_name==null||comp_name.length()<=0||comp_name.equalsIgnoreCase("NA"))
					comp_name="....";
	//			System.out.println(clientrefid+"/"+comp_name);
				if(!comp_name.equals("....")){
					String clientcomp[]=Enquiry_ACT.getClientCompanyDetail(comp_name,token);
					
					if(clientcomp[0]!=null&&!clientcomp[0].equalsIgnoreCase("NA")){statecode=clientcomp[0].trim();}
					else if(clientcomp[1]!=null&&!clientcomp[1].equalsIgnoreCase("NA")){statecode=clientcomp[0].substring(0,2);}
					
					String comp[]=Enquiry_ACT.getCompanyDetail(token);
					
					if(comp[0]!=null&&!comp[0].equalsIgnoreCase("NA")){cstatecode=comp[0].trim();}
					else if(comp[1]!=null&&!comp[1].equalsIgnoreCase("NA")){cstatecode=comp[0].substring(0,2);}
				}else {
					//find company if client name doesn't exist with name.Exist with contact name
					String clientcomp[]=Clientmaster_ACT.getClientDetailsByEmail(contact[0][1],token);
					
					if(clientcomp[0]!=null&&!clientcomp[0].equalsIgnoreCase("NA")){statecode=clientcomp[0].trim();}
					else if(clientcomp[1]!=null&&!clientcomp[1].equalsIgnoreCase("NA")){statecode=clientcomp[0].substring(0,2);}
					
					String comp[]=Enquiry_ACT.getCompanyDetail(token);
					if(comp[0]!=null&&!comp[0].equalsIgnoreCase("NA")){cstatecode=comp[0].trim();}
					else if(comp[1]!=null&&!comp[1].equalsIgnoreCase("NA")){cstatecode=comp[0].substring(0,2);}
				}
	//			System.out.println("cstate code="+cstatecode+"/"+statecode);
				String remarks = request.getParameter("enqRemarks").trim();
				
				if(salesType.equalsIgnoreCase("1")) {
					//getting all products and create separate sales
					String[][] productlist=Enquiry_ACT.getSalesProductList(salesid,token,addedby);
					if(productlist.length>0&&productlist!=null){
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
						//getting coupon and apply again discount
						double orderAmount=0;
						double discount=0;
						String couponType="NA";
						String value="0";
						String coupon=request.getParameter("applyCoupon");
						String today1=DateUtil.getCurrentDateIndianReverseFormat();
						if(coupon!=null&&coupon.length()>0) {
							String couponData[][]=Coupon_ACT.getCouponByTitle(coupon,today1,token);
							if(couponData!=null&&couponData.length>0) {
								couponType=couponData[0][4];
								coupon=couponData[0][2];
								value=couponData[0][3];
		//						System.out.println(couponType+"/"+coupon);
								String services[][]=Enquiry_ACT.getVirtualProductList(salesid,token);
								if(services!=null&&services.length>0) {
									for(int i=0;i<services.length;i++) {
										double serviceAmount=TaskMaster_ACT.getProductPrice(services[i][0], token);
										if(couponData[0][13].equals("selected")) {
											String productNo=TaskMaster_ACT.getProductNo(services[i][0], token);
											boolean flag=Coupon_ACT.isCouponServiceExist(productNo, couponData[i][1]);
											if(flag) {
												orderAmount+=(serviceAmount*Integer.parseInt(services[i][1]));
											}
										}else if(couponData[0][13].equals("all")){
											orderAmount+=serviceAmount;
										}
									}
								}					
							if(orderAmount>0&&couponData[0][4].equals("percentage")) {
								discount=(orderAmount*Double.parseDouble(couponData[0][3]))/100;
								//check max discount
								double maxDiscount=Double.parseDouble(couponData[0][11]);
								if(discount>maxDiscount)discount=maxDiscount;
								}else if(orderAmount>0&&couponData[0][4].equals("fixed")){
									discount=Double.parseDouble(couponData[0][3]);
								}
							discount=Math.floor(discount);
		//					System.out.println(orderAmount+"/"+discount);
							}
						}else {
							coupon="NA";
						}					
						String soldBy=loginuaid;
						String estimateKey="NA";
						double estimateAmount=0;
						if(soldBySale!=null&&soldBySale.length()>0) {
							soldBy=soldBySale;
						}
						for(int i=0;i<productlist.length;i++){
							String prodrefid=productlist[i][2];
							//getting product type and product name
							String productdetails[]=Enquiry_ACT.getSalesProductType(prodrefid, token);
							
							//creating sales ref key
							String key =RandomStringUtils.random(40, true, true); 
							if(i==0)
							estimateKey=key;
							//creating new sales
							String[] prodplan=Enquiry_ACT.getProductPlan(productlist[i][0],token);
							if(prodplan.length>0&&prodplan!=null){
		//						System.out.println("going to save client refid==="+clientrefid);
								status = Enquiry_ACT.AddEstimateSale(newsalesid, productdetails[0], comp_name,remarks,addedby,token,
										productdetails[1],key,today,soldBy,contactrefid,clientrefid,prodplan[0],prodplan[1],
										prodplan[2],productlist[i][3],coupon,couponType,discount,value,loginuaid,notes,
										prodplan[3],orderNo,purchaseDate,Integer.parseInt(productdetails[3]),productdetails[4],salesType);
							if(status){
								String milestones[][]=Enquiry_ACT.getProductMilestone(productdetails[2], token);
								if(milestones!=null&&milestones.length>0)
									for(int j=0;j<milestones.length;j++){
										String pricePercKey=RandomStringUtils.random(40, true, true); 
										status=Enquiry_ACT.addPricePercentage(pricePercKey,key,milestones[j][7],milestones[j][1],"Full Pay",milestones[j][6],token,addedby,newsalesid);
									}
							}
							}
							//getting products price details and adding to final sales price table
							String[][] product=Enquiry_ACT.getEachProductsPriceDetails(productlist[i][0],token,addedby);
							if(product!=null&&product.length>0){
								for(int j=0;j<product.length;j++){
									int qty=Integer.parseInt(product[j][9]);
									String hsn=product[j][3];
									double cgstprice=0;
									double sgstprice=0;
									double igstprice=0;
									double totalprice=0;						
									double cgst=Double.parseDouble(product[j][4]);
									double sgst=Double.parseDouble(product[j][5]);
									double igst=Double.parseDouble(product[j][6]);
									double price=CommonHelper.convertUptoDecimal((Double.parseDouble(product[j][2])*qty),2);
									
									if(cstatecode.equalsIgnoreCase(statecode)){
										cgstprice=CommonHelper.findPercent(price,cgst);
										sgstprice=CommonHelper.findPercent(price,sgst);
										
										totalprice=CommonHelper.convertUptoDecimalAndRound((price+cgstprice+sgstprice),2);
										igst=0;
									}else{
										igstprice=CommonHelper.findPercent(price,igst);
										totalprice=CommonHelper.convertUptoDecimalAndRound((price+igstprice),2);
										sgst=0;
										cgst=0;
									}	
									estimateAmount+=totalprice;
									
									Enquiry_ACT.saveSalesProductPrice(newsalesid,product[j][0],product[j][1],price,hsn,cgst,sgst,igst,cgstprice,sgstprice,igstprice,totalprice,product[j][8],token,addedby,key,product[j][10]);
								}
								estimateAmount-=discount;
							}
							//getting each product's documents
							String document[][]=Enquiry_ACT.getSalesDocumentList(prodrefid,token);	
							if(document!=null&&document.length>0){
								for(int a=0;a<document.length;a++){
									String dockey=RandomStringUtils.random(40, true, true);
									Enquiry_ACT.addDocumentList(dockey,"NA",document[a][0],document[a][1],document[a][2],addedby,token,document[a][3],key);
								}
							}
						}
								
					if(status){
						Clientmaster_ACT.clearProductPriceCart(token,addedby);
		//				Clientmaster_ACT.clearProductPaymentCartFinal(token,addedby);
						Clientmaster_ACT.clearSalesContactCart(token,addedby);  
						Clientmaster_ACT.clearProductPricePlanCart(token,addedby);
					}
					//adding estimate notification
					String estremarks="Estimate invoice created";
					String estKey=RandomStringUtils.random(40,true,true);
					Clientmaster_ACT.saveEstimateNotification(estKey,newsalesid,loginuaid,estremarks,today,token);
					//adding notification
					String nKey=RandomStringUtils.random(40,true,true);
					String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
					String message="Estimate : "+salesid+" is created by &nbsp;<span class=\"text-muted\">"+userName+"</span>";			
					TaskMaster_ACT.addNotification(nKey,today,soldBy,"2","manage-estimate.html",message,token,loginuaid,"fas fa-receipt");
					
					if(!soldBy.equals(loginuaid)) {
						message="Estimate : "+salesid+" is successfully created.";	
						nKey=RandomStringUtils.random(40,true,true);
						TaskMaster_ACT.addNotification(nKey,today,loginuaid,"2","manage-estimate.html",message,token,loginuaid,"fas fa-receipt");
					}//getting
					
					//sending email to client of successfully estimate created			
					String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
							+ "         \n"
							+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
							+ "        \n"
							+ "                <a href=\"#\" target=\"_blank\">\n"
							+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
							+ "            </td></tr>\n"
							+ "            <tr>\n"
							+ "              <td style=\"text-align: center;\">\n"
							+ "                <h1>"+newsalesid+"</h1>"
							+ "              </td></tr>"
							+ "        <tr>\n"
							+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
							+ "            Hi "+comp_name+",</td></tr>"
							+ "             <tr>\n"
							+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
							+ "                     <p> Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below. \n"
							+ "                      </p>\n"					
							+ "                    </td></tr>  \n"
							+ "                   \n"
							+ "                         <tr>\n"
							+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
							+ "                                  <h2 style=\"text-align: center;\">Estimate Amount</h2>\n"
							+ "                                 <p style=\"text-align: center;\">Rs. "+estimateAmount+"\n"
							+ "                                  </p>\n"
							+ "                                <p style=\"text-align: center;\">Estimate No. : "+newsalesid+"</p>\n"
							+ "                                <p style=\"text-align: center;\">Estimate Date : "+today+" \n"
							+ "                                 </p>\n"
							+ "                                <a href=\""+domain+"invoice-"+estimateKey+".html\"><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">View Invoice</button>\n"
							+ "                                </td></tr>  \n"
							+ "         \n"
							+ "          \n"
							+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
							+ "                <b>Estimate no #"+newsalesid+"</b><br>\n"
							+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
							+ "                \n"
							+ "        \n"
							+ "    </td></tr> \n"
							+ "      \n"
							+ "    </table>";
					if(contactEmail!=null&&!contactEmail.equalsIgnoreCase("NA")&&contactEmail.length()>0)
					Enquiry_ACT.saveEmail(contactEmail,"empty","Estimate : "+newsalesid+" generated", message1,2,token);
					}
				}else {
					String consultationType=request.getParameter("consultationType");
					if(consultationType==null||consultationType.length()<=0)consultationType="NA";
					
					String consultationRenewalValue=request.getParameter("consultationRenewalValue");
					if(consultationRenewalValue==null||consultationRenewalValue.length()<=0)consultationRenewalValue="0";
					
					String consultationRenewalType=request.getParameter("consultationRenewalType");
					if(consultationRenewalType==null||consultationRenewalType.length()<=0)consultationRenewalType="NA";
					
					String consultationEndDate=request.getParameter("consultationEndDate");
					if(consultationEndDate==null||consultationEndDate.length()<=0)consultationEndDate="NA";
					
					String consultationFeeType=request.getParameter("consultationFeeType");
					if(consultationFeeType==null||consultationFeeType.length()<=0)consultationFeeType="NA";
					
					String consultationFee=request.getParameter("consultationFee");
					if(consultationFee==null||consultationFee.length()<=0)consultationFee="0";
					
					String consultationHsn=request.getParameter("consultationHsn");
					if(consultationHsn==null||consultationHsn.length()<=0)consultationHsn="NA";
					
					String consultantUaid=request.getParameter("consultantUaid");
					if(consultantUaid==null||consultantUaid.length()<=0)consultantUaid="NA";
					
//					System.out.println("consultationType="+consultationType+"\nconsultationRenewalValue="+consultationRenewalValue
//							+"\nconsultationRenewalType="+consultationRenewalType+"\nconsultationEndDate="+consultationEndDate
//							+"\nconsultationFeeType="+consultationFeeType+"\nconsultationFee="+consultationFee
//							+"\nconsultationHsn="+consultationHsn);
					
					
//					String saleno, String prodtype, String company,String Remarks,String addedby,
//					String token,String product_name,String key,String today,String loginuaid,String contactrefid,
//					String clientrefid,String plan,String planperiod,String plantime,String qty,String coupon,
//					String couponType,double discount,String value,String addedByUid,String notes,String jurisdiction,
//					String orderNo,String purchaseDate,int tatValue,String tatType
					
					String newsalesid=Enquiry_ACT.getEstimateEnqUID(token);
					String initial = Usermaster_ACT.getStartingCode(token,"imestimatebillingkey");
					if (newsalesid==null||newsalesid.equalsIgnoreCase("0") || newsalesid.equalsIgnoreCase("")) {
						newsalesid=initial+"1";
					}else {
						   String enq=newsalesid.substring(initial.length());
						   int j=Integer.parseInt(enq)+1;
						   newsalesid=initial+Integer.toString(j);
						}
					
					String estimateKey =RandomStringUtils.random(40, true, true); 
					
					String soldBy=loginuaid;
					if(soldBySale!=null&&soldBySale.length()>0) {
						soldBy=soldBySale;
					}
					
					boolean enqFlag=Enquiry_ACT.AddEstimateSale(newsalesid, "NA", comp_name,remarks,addedby,token,
							"Consultation Service",estimateKey,today,soldBy,contactrefid,clientrefid,"NA","NA",
							"NA","1","NA","NA",0.0,"0",loginuaid,notes,"NA",orderNo,purchaseDate,0,"NA",salesType);
					if(enqFlag) {
						double cgstprice=0;
						double sgstprice=0;
						double igstprice=0;
						double totalprice=0;						
						double cgst=0;
						double sgst=0;
						double igst=0;
						double price=Double.parseDouble(consultationFee);
						
						String[] hsn=TaskMaster_ACT.findHsnDetails(consultationHsn,token);
						if(hsn!=null&&hsn.length>0) {
							if(hsn[0]!=null&&!hsn[0].equalsIgnoreCase("NA"))sgst=Double.parseDouble(hsn[0]);
							if(hsn[1]!=null&&!hsn[1].equalsIgnoreCase("NA"))cgst=Double.parseDouble(hsn[1]);
							if(hsn[2]!=null&&!hsn[2].equalsIgnoreCase("NA"))igst=Double.parseDouble(hsn[2]);
						}
						
						if(cstatecode.equalsIgnoreCase(statecode)){
							cgstprice=Math.round((price*cgst)/100);
							sgstprice=Math.round((price*sgst)/100);
							
							totalprice=price+cgstprice+sgstprice;
							igst=0;
						}else{
							igstprice=Math.round((price*igst)/100);
							totalprice=price+igstprice;
							sgst=0;
							cgst=0;
						}						
						
						String refid =RandomStringUtils.random(40, true, true); 
						boolean priceFlag=Enquiry_ACT.saveSalesProductPrice(newsalesid,"NA",consultationFeeType,price,consultationHsn,cgst,
								sgst,igst,cgstprice,sgstprice,igstprice,totalprice,refid,token,addedby,estimateKey,"0");
						if(priceFlag) {
							int days=0;
							if(consultationRenewalType.equalsIgnoreCase("Day"))
								days=Integer.parseInt(consultationRenewalValue);
							else if(consultationRenewalType.equalsIgnoreCase("Month"))
								days=Integer.parseInt(consultationRenewalValue)*30;
							else if(consultationRenewalType.equalsIgnoreCase("Year"))
								days=Integer.parseInt(consultationRenewalValue)*365;
							
							String lastPaymentDate=DateUtil.getCurrentDateIndianReverseFormat();
							String dateAfterDays="NA";
							
							if(consultationType.equalsIgnoreCase("Renewal"))
								dateAfterDays=DateUtil.getDateAfterDaysFromDate(days, lastPaymentDate);
							
							Enquiry_ACT.saveConsultingSale(estimateKey,consultationType,consultationRenewalValue,consultationRenewalType,consultationEndDate,
									consultationFeeType,Double.parseDouble(consultationFee),consultationHsn,cgst,sgst,igst,cgstprice,sgstprice,igstprice,
									totalprice,token,today,dateAfterDays,consultantUaid);
						}
						
						//adding estimate notification
						String estremarks="Estimate invoice created";
						String estKey=RandomStringUtils.random(40,true,true);
						Clientmaster_ACT.saveEstimateNotification(estKey,newsalesid,loginuaid,estremarks,today,token);
						//adding notification
						String nKey=RandomStringUtils.random(40,true,true);
						String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
						String message="Estimate : "+salesid+" is created by &nbsp;<span class=\"text-muted\">"+userName+"</span>";			
						String soldByUaid="NA";
						if(soldBySale!=null&&soldBySale.length()>0) {
							soldByUaid=soldBySale;
						}else soldByUaid=loginuaid;
						
						TaskMaster_ACT.addNotification(nKey,today,soldByUaid,"2","manage-estimate.html",message,token,loginuaid,"fas fa-receipt");
						
						if(soldBySale!=null&&!soldBySale.equalsIgnoreCase("NA")&&!soldBySale.equals(loginuaid)) {
							message="Estimate : "+salesid+" is successfully created.";	
							nKey=RandomStringUtils.random(40,true,true);
							TaskMaster_ACT.addNotification(nKey,today,loginuaid,"2","manage-estimate.html",message,token,loginuaid,"fas fa-receipt");
						}//getting
						
						//sending email to client of successfully estimate created			
						String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
								+ "         \n"
								+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
								+ "        \n"
								+ "                <a href=\"#\" target=\"_blank\">\n"
								+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
								+ "            </td></tr>\n"
								+ "            <tr>\n"
								+ "              <td style=\"text-align: center;\">\n"
								+ "                <h1>"+newsalesid+"</h1>"
								+ "              </td></tr>"
								+ "        <tr>\n"
								+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
								+ "            Hi "+comp_name+",</td></tr>"
								+ "             <tr>\n"
								+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
								+ "                     <p> Thank you for contacting us. Your Estimate can be Viewed, Printed and Downloaded as PDF from the link below. \n"
								+ "                      </p>\n"					
								+ "                    </td></tr>  \n"
								+ "                   \n"
								+ "                         <tr>\n"
								+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
								+ "                                  <h2 style=\"text-align: center;\">Estimate Amount</h2>\n"
								+ "                                 <p style=\"text-align: center;\">Rs. "+CommonHelper.withLargeIntegers(totalprice)+"\n"
								+ "                                  </p>\n"
								+ "                                <p style=\"text-align: center;\">Estimate No. : "+newsalesid+"</p>\n"
								+ "                                <p style=\"text-align: center;\">Estimate Date : "+today+" \n"
								+ "                                 </p>\n"
								+ "                                <a href=\""+domain+"invoice-"+estimateKey+".html\"><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">View Invoice</button>\n"
								+ "                                </td></tr>  \n"
								+ "         \n"
								+ "          \n"
								+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
								+ "                <b>Estimate no #"+newsalesid+"</b><br>\n"
								+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
								+ "                \n"
								+ "        \n"
								+ "    </td></tr> \n"
								+ "      \n"
								+ "    </table>";
						if(contactEmail!=null&&!contactEmail.equalsIgnoreCase("NA")&&contactEmail.length()>0)
						Enquiry_ACT.saveEmail(contactEmail,"empty","Estimate : "+newsalesid+" generated", message1,2,token);
						status=true;
						Clientmaster_ACT.clearSalesContactCart(token,addedby);  
					}					
				}
				
				if (status) {
					response.sendRedirect(request.getContextPath() + "/manage-estimate.html");
					
				} else {
					session.setAttribute("ErrorMessage", "Something Went Wrong , Try-again later!");
					response.sendRedirect(request.getContextPath() + "/notification.html");
				}
			}else {
				session.setAttribute("ErrorMessage", "Something Went Wrong , Try-again later!");
				response.sendRedirect(request.getContextPath() + "/notification.html");
			}
			}
		
		}catch (Exception e) {
			e.printStackTrace();
		}

	}
}