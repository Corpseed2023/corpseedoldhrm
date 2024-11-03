package admin.enquiry;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;

import admin.Login.LoginAction;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import commons.CommonHelper;
import commons.DateUtil;

@SuppressWarnings("serial")
public class ApproveSalePaymentCTRL extends HttpServlet {
	private static Logger log = Logger.getLogger(LoginAction.class);

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		PrintWriter pw=response.getWriter();		
try{		
		boolean status=false;
		Properties properties = new Properties();
		properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
		String domain=properties.getProperty("domain");
		String token = (String) session.getAttribute("uavalidtokenno");	
		String addedby = (String)session.getAttribute("loginuID");
		String today=DateUtil.getCurrentDateIndianFormat1();
		String loginuaid = (String)session.getAttribute("loginuaid");
		String refid=request.getParameter("refid").trim();
		String invoiceno=request.getParameter("invoiceno").trim();
		String clientrefid=request.getParameter("clientrefid").trim();
		String clientkey="NA";
		String contactrefid=request.getParameter("contactrefid").trim();
		String comment=request.getParameter("comment").trim();
		
		String contact[]=Enquiry_ACT.getClientContactByKey(contactrefid, token);
		String contactname="NA";
		String contactmobile="NA";
		String contactemail="NA";
		if(contact[0]!=null&&contact[0]!="")contactname=contact[0];
		if(contact[1]!=null&&contact[1]!="")contactmobile=contact[1];
		if(contact[2]!=null&&contact[2]!="")contactemail=contact[2];
		
//		System.out.println("contactemail===="+contactemail);
		
		if(clientrefid==null||clientrefid.equalsIgnoreCase("NA")){
//			String isClientKey=Clientmaster_ACT.getClientKeyByEmail(contactemail, token);
//			if(isClientKey==null||isClientKey.equals("NA")) {
				clientkey=RandomStringUtils.random(40,true,true);
				//new client no
				String cregucid=Clientmaster_ACT.getetocode(token);
				String initial = Usermaster_ACT.getStartingCode(token,"imclientkey");
				if (cregucid==null) {
					cregucid=initial+"1";
				}else {	String c=cregucid.substring(initial.length());				
						int j=Integer.parseInt(c)+1;
						cregucid=initial+Integer.toString(j);}
	//			System.out.println("cregucid="+cregucid);
				//register new client			
				status=Clientmaster_ACT.saveClientDetail(cregucid,addedby, token,clientkey,contactname,contactemail,contactmobile);
				Clientmaster_ACT.openAccount(cregucid, "NA", addedby,token);
				//updating client's ref id into billing
				Enquiry_ACT.updateClientKeyInBilling(invoiceno,clientkey,token);
				clientrefid=clientkey;
				//update client key in estimate
				
	//			System.out.println("clientkey="+clientkey);	
//		}else {
//			clientrefid=isClientKey;
//		}
		}else {
			clientkey=clientrefid;
		} 
		
//		System.out.println("clientrefid====="+clientrefid+"/clientkey=="+clientkey);
		String clientid=Enquiry_ACT.getClientIdByRefid(clientrefid, token);
		String accountid=Enquiry_ACT.getClientsAccountid(clientid, token);
		//getting transaction amount before update with new
		double amount=Enquiry_ACT.getTransactionAmount(refid,token);
		String paymentMode=Enquiry_ACT.getPaymentMode(refid,token);
		String clientname=Clientmaster_ACT.getClientName(clientid, token);
		
		if(refid!=null&&refid.length()>0){
			String invoice="NA";
			String isInvoice=Enquiry_ACT.getBillingInvoiceNumber(invoiceno, token);
			if(isInvoice==null||isInvoice.length()<=0||isInvoice.equalsIgnoreCase("NA")){				
				//getting client's unique no				
				String clientno=Clientmaster_ACT.getClientNo(clientid, token);
				
				String clientContact[][]=Enquiry_ACT.findSalesContactsByKey(contactrefid, token);
				if(clientContact!=null&&clientContact.length>0) {
					for(int i=0;i<clientContact.length;i++) {
						boolean clientflag=Usermaster_ACT.isClientsLoginId(clientContact[i][1],token);
						if(!clientflag){					
							//creating user register
							String uapassword=RandomStringUtils.random(8,true,true);
							String loginkey=RandomStringUtils.random(40,true,true);
							String uacompany= (String)session.getAttribute("uacompany");
							String uaaip = request.getRemoteAddr();
							String uaabname = request.getHeader("User-Agent");
							int super_user_id=Clientmaster_ACT.findClientSuperUserId(clientid,token);
							int contact_id=Clientmaster_ACT.findContactId(clientContact[i][3],token);
							String username="";
							if(clientContact[i][1]!=null&&clientContact[i][1].length()>0) {
								if(clientContact[i][1].length()>10)username=clientContact[i][1].substring(clientContact[i][1].length()-10);
								else username=clientContact[i][1];
							}else username=RandomStringUtils.random(10, true, true);
							
							status=Usermaster_ACT.saveUserDetail(token,username,uapassword,clientContact[i][0],clientContact[i][1],clientContact[i][2],"NA",addedby,uaaip,uaabname,"Client",clientno, uacompany,loginkey,"NA","ROLE_USER","0.0.0","2",super_user_id,contact_id);
						    //mapping client user info
							int clientUserUaid=Usermaster_ACT.findUserUaidByMobile(clientContact[i][1],token);
							Clientmaster_ACT.saveClientUserInfo(Integer.parseInt(clientid), clientUserUaid, today, token); 
							//send login detail to client's mobile
							//BY EMAIL
							if(status) {
		//					String message="<p>Dear "+contactname+"</p><p>Your login details is here !</p><br/><p>Username : "+contactmobile+"</p><p>Password : "+uapassword+"</p><p>Login link : <a href='"+domain+"'>link</a></p><br><p>Thanks & Regards</p><p>HR(Renu Mayal)</p>";
							String message="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
									+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
									+ "                <a href=\"#\" target=\"_blank\">\n"
									+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
									+ "            </td></tr>\n"
									+ "            <tr>\n"
									+ "              <td style=\"text-align: center;\">\n"
									+ "                <h1>Thank You</h1><p style=\"text-align:center\">"+clientContact[i][0]+" Order Confirmation("+invoiceno+")</p>"					
									+ "              </td></tr>"
									+ "        <tr>\n"
									+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
									+ "            Hi "+clientContact[i][0]+",</td></tr>"
									+ "             <tr>\n"
									+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
									+ "                     <p> Thank you for choosing Corpseed for your business. Your order has been received. \n"
									+ "                      </p><p>Use link to <a href=\""+domain+"client_orders.html\">track your order</a>.</p>\n"					
									+ "                    <p>Your login credentials for the order :-<br>Username :- "+clientContact[i][1]+"<br>Password :- "+uapassword+"</p>"
									+ "						<p><b>Note:-</b> Please don\"t share these credentials with anyone.</p></td></tr>  \n"
								
									+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
									+ "                <b>Estimate/Invoice #"+invoiceno+"</b><br>\n"
									+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
									+ "    </td></tr> \n"
									+ "    </table>";
							
							try {
							
							Enquiry_ACT.saveEmail(clientContact[i][2],"empty","Corpseed | Login credentials", message,2,token); 
							
							//BY SMS
		//					Usermaster_ACT.sendRegistrationSms(uapassword,addedby,contactmobile);
							}catch(Exception e) {e.printStackTrace();}
							}					
						}else {							
							//find client user mapped or not if not then insert
							int clientUserUaid=Usermaster_ACT.findUserUaidByMobile(clientContact[i][1],token);
							if(clientUserUaid>0) {
								boolean isSU=Usermaster_ACT.isClientSuperUser(clientUserUaid,token);
								if(!isSU) {
									boolean cuflag=Clientmaster_ACT.isClientUserMapped(Integer.parseInt(clientid),clientUserUaid,token);
									if(!cuflag) {
										Clientmaster_ACT.saveClientUserInfo(Integer.parseInt(clientid), clientUserUaid, today, token); 
									}
								}
							}
						}
					}
				}
				//getting login user uaid
//				System.out.println("going to find clientLoginUaid./..");
//				int clientUserUaid=Usermaster_ACT.findUserUaidByMobile(contactmobile,token);
//				System.out.println("found clientLoginUaid./.."+clientUserUaid);
//				if(clientUserUaid>0)
//					Clientmaster_ACT.saveClientUserInfo(Integer.parseInt(clientid),clientUserUaid,today,token);
//				
//				System.out.println("Client user saved.............");
				//checking client's folder exist or not, if not create new with client's name
				String folderrefid=Enquiry_ACT.getFolderRefIdByClientId(clientid, token);
				if(folderrefid==null||folderrefid.equalsIgnoreCase("NA")){
					if(clientname==null||clientname.equalsIgnoreCase("NA")||clientname.length()<=0)clientname=clientno;
					//create new folder with client name
					folderrefid=RandomStringUtils.random(40, true, true);		
					boolean flag=Enquiry_ACT.createClientFolder(folderrefid, clientname, addedby, token, "Main", "sales", "NA",clientid);
					if(!flag)folderrefid="NA";
				}	
				//change draft to invoiced of estimate sale
				Enquiry_ACT.updateEstimateToInvoiced(invoiceno,token);
				//generating invoice Number
				invoice=Enquiry_ACT.getInvoiceNumber(token);
				String initial = Usermaster_ACT.getStartingCode(token,"imbillingkey");
				if (invoice==null||invoice.equalsIgnoreCase("NA") || invoice.equalsIgnoreCase("")) {
					invoice=initial+"1";
				}else {
					   String enq=invoice.substring(initial.length());
					   int j=Integer.parseInt(enq)+1;
					   invoice=initial+Integer.toString(j);
					}			
				//inserting invoice number into invoice table
				status=Enquiry_ACT.saveNewInvoice(invoice,addedby,token);
//				System.out.println(invoice);
				//updating invoice into billing table
				status=Enquiry_ACT.updateBillingInvoice(invoice,invoiceno,token); 
				//updating invoice into estimate sales payment
				status=Enquiry_ACT.updatePaymentInvoice(invoice,invoiceno,token); 
				//coping estimate product into sales
				String estproduct[][]=Enquiry_ACT.getEstimateProducts(invoiceno,token);
				boolean docUploaded=true;
				if(estproduct!=null&&estproduct.length>0){
					for(int i=0;i<estproduct.length;i++){	
//						System.out.println("if condition==="+clientkey);
						if(!clientkey.equalsIgnoreCase("NA")){
							//updating client refKey to main contact box estproduct[i][10]
							String contactKey[][]=Enquiry_ACT.getContactKey(estproduct[i][10],token);
							if(contactKey!=null&&contactKey.length>0)
							for(int k=0;k<contactKey.length;k++)
							status=Enquiry_ACT.updateClientKeyInContact(contactKey[k][0],clientkey,token);
							//updating estimate sale client refId
							status=Enquiry_ACT.updateClientKeyInEstimate(estproduct[i][0],clientkey,token);
						}
						int qty=Integer.parseInt(estproduct[i][3]);
						for(int k=0;k<qty;k++){
							//generating project Number
							String projectno=Enquiry_ACT.getProjectNumber(token);
							String start = Usermaster_ACT.getStartingCode(token,"improjectkey");
							if (projectno==null||projectno.equalsIgnoreCase("NA") || projectno.equalsIgnoreCase("")) {
								projectno=start+"1";
							}else {
							   String enq=projectno.substring(start.length());
							   int j=Integer.parseInt(enq)+1;
							   projectno=start+Integer.toString(j);
							}
						String saleskey=RandomStringUtils.random(40, true, true);
						String clientRefKey=estproduct[i][11];
						if(clientRefKey==null||clientRefKey.equalsIgnoreCase("NA")||clientkey.length()<=0)clientRefKey=clientkey;
						//insert estimate product details into managesalesctrl 
						status=Enquiry_ACT.convertEstimateToSale(saleskey,estproduct[i][1],estproduct[i][2],
								estproduct[i][4],estproduct[i][5],estproduct[i][6],estproduct[i][7],today,
								estproduct[i][9],estproduct[i][10],clientRefKey,estproduct[i][12],token,
								addedby,invoice,invoiceno,projectno,estproduct[i][13],estproduct[i][14],
								estproduct[i][0],estproduct[i][15],estproduct[i][16],Integer.parseInt(estproduct[i][17])
								,estproduct[i][18],Integer.parseInt(estproduct[i][19]));
						
						if(status){
							if(clientContact!=null&&clientContact.length>0) {
								for(int x=0;x<clientContact.length;x++) {									
									int clientUserUaid=Usermaster_ACT.findUserUaidByMobile(clientContact[x][1],token);
									if(clientUserUaid>0) {
										boolean isSU=Usermaster_ACT.isClientSuperUser(clientUserUaid,token);
										if(!isSU) {
											int salesId=Enquiry_ACT.findSalesIdByKey(saleskey,token);
											Clientmaster_ACT.saveClientUserSalesInfo(salesId, clientUserUaid, today, token);
										}
									}
								}
							}							
							
							if(!folderrefid.equalsIgnoreCase("NA")){							
								String subfolkey=RandomStringUtils.random(40, true, true);	
								//create project folder
								Enquiry_ACT.createProjectFolder(folderrefid, projectno, addedby, token, "Sub", "Sales", saleskey, clientid,subfolkey);
							}						
							String projprice[][]=Enquiry_ACT.getEstimateSalesPrice(estproduct[i][0],token);
							String prodrefid="NA";
							if(projprice!=null&&projprice.length>0){
								for(int j=0;j<projprice.length;j++){
								//calculating cgst,sgst,igst price and total
								prodrefid=projprice[j][0];
								double cgstprice=0;
								double sgstprice=0;
								double igstprice=0;
								double total=0;
								double price=CommonHelper.convertUptoDecimal(Double.parseDouble(projprice[j][2])/Integer.parseInt(estproduct[i][3]),2);							
								double cgstpercent=Double.parseDouble(projprice[j][4]);
								double sgstpercent=Double.parseDouble(projprice[j][5]);
								double igstpercent=Double.parseDouble(projprice[j][6]);
								if(cgstpercent>0){cgstprice=CommonHelper.findPercent(price, cgstpercent);}
								if(sgstpercent>0){sgstprice=CommonHelper.findPercent(price, sgstpercent);}
								if(igstpercent>0){igstprice=CommonHelper.findPercent(price, igstpercent);}
								
								total=CommonHelper.convertUptoDecimalAndRound((price+cgstprice+sgstprice+igstprice),2);
								String pricekey=RandomStringUtils.random(40, true, true);
								//insert estimate price details into project price table
								Enquiry_ACT.convertEstimatePriceToSale(pricekey,saleskey,prodrefid,projprice[j][1],price,projprice[j][3],cgstpercent,sgstpercent,igstpercent,cgstprice,sgstprice,igstprice,total,token,addedby);
								
							}}
							//updating saleskey in documents
							Enquiry_ACT.updateDocumentList(estproduct[i][0],saleskey,token);
							//update sales document history
							Enquiry_ACT.updateSalesDocHistory(estproduct[i][0],saleskey,token);
							//checking all document uploadedor not
							if(docUploaded)
								docUploaded=Enquiry_ACT.isAllDocumentUploaded(estproduct[i][0],token);
							
							
							//create project documents list
	//						String document[][]=Enquiry_ACT.getSalesDocumentList(prodrefid,token);	
	//						if(document!=null&&document.length>0){
	//							for(int a=0;a<document.length;a++){
	//								String dockey=RandomStringUtils.random(40, true, true);
	//								Enquiry_ACT.addDocumentList(dockey,saleskey,document[a][0],document[a][1],document[a][2],addedby,token,document[a][3]);
	//							}
	//						}
//							System.out.println("estproduct[i][19]=="+estproduct[i][19]);
							if(estproduct[i][19].equals("1")) {
								String milestone[][]=Enquiry_ACT.getProductMilestone(prodrefid,token);
								int totalDays=0;
								int totalMinutes=0;
								if(milestone!=null&&milestone.length>0){
									for(int l=0;l<milestone.length;l++){
										String milestonekey=RandomStringUtils.random(40, true, true);
										String pricePercent=Enquiry_ACT.getSalesPricePercentage(estproduct[i][0],milestone[l][7],token);
										String x[]=pricePercent.split("#");
										pricePercent=x[0];
										String payType=x[1];
										//insert product's milestone into project milestone table
										Enquiry_ACT.saveMilestoneToSale(milestonekey,saleskey,milestone[l][0],milestone[l][1],milestone[l][2],milestone[l][3],milestone[l][4],milestone[l][5],pricePercent,addedby,token,payType);
										if(milestone[l][3].equalsIgnoreCase("Week"))totalDays+=(Integer.parseInt(milestone[l][2])*7);
										else if(milestone[l][3].equalsIgnoreCase("Month"))totalDays+=(Integer.parseInt(milestone[l][2])*30);
										else if(milestone[l][3].equalsIgnoreCase("Day"))totalDays+=Integer.parseInt(milestone[l][2]);
										else if(milestone[l][3].equalsIgnoreCase("Hour"))totalMinutes+=(Integer.parseInt(milestone[l][2])*60);
										else if(milestone[l][3].equalsIgnoreCase("Minute"))totalMinutes+=Integer.parseInt(milestone[l][2]);
									}
								}
							
								String deliveryDate="NA";
								String deliveryTime="NA";
								//inserting in action history for triggers
								String dhKey=RandomStringUtils.random(40, true, true);	
								String deliveryData[] = DateUtil.getLastDate(today, totalDays,totalMinutes); 		   /* precStatus,currentStatus,p-n-teamKey*/
								if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
								if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
								status=TaskMaster_ACT.saveDeliveryActionHistory(dhKey,saleskey,deliveryDate,"Inactive","Inactive","NA","NA","Low","Low",today,token,loginuaid,deliveryTime);						
		//						System.out.println(deliveryDate+" Approve payment days : "+totalDays);
								
								//updating saleskey in sales_notification
								TaskMaster_ACT.updateSalesKeyInSalesNotification(saleskey,estproduct[i][0],token);
							}else if(estproduct[i][19].equals("2")) {
//								System.out.println("consulting sale................");
								String consultantUaid=Enquiry_ACT.findConsultantUaid(estproduct[i][0],token);
								String userNKey=RandomStringUtils.random(40,true,true);
								String userMessage="Invoice No. : <span class='text-info'>"+invoice+"</span> Consulting Service assigned to you, Do needful.";
								TaskMaster_ACT.addNotification(userNKey,today,consultantUaid,"2","manage-sales.html?inv="+invoice,userMessage,token,loginuaid,"fas fa-rupee-sign");
								Enquiry_ACT.updateSalesKeyInConsultingSale(saleskey,estproduct[i][0],token);
							}
							//send email on estimate notes
							String estNotes[][]=Enquiry_ACT.getEstimateNotesByEstimateKey(estproduct[i][0],token);
							for(int e=0;e<estNotes.length;e++) {
	//							System.out.println("going to update send estimate notes...."+e);
								Enquiry_ACT.sendEstimateNotes(estNotes[e][0],estNotes[e][1],estNotes[e][2],estNotes[e][3],saleskey,estproduct[i][0],token);
								//updating status 2
	//							System.out.println("going to update estimate notes....");
								Enquiry_ACT.updateEstimateNotesStatus(estNotes[e][4],token);
							}
						}
					}
				}
					
					//adding notification
					String nKey=RandomStringUtils.random(40,true,true);
					String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
					String message="Estimate no. : "+invoiceno+" converted to sales invoice :"+invoice+" by &nbsp;<span class=\"text-muted\">"+userName+"</span>";
					TaskMaster_ACT.addNotification(nKey,today,estproduct[0][9],"2","manage-sales.html",message,token,loginuaid,"far fa-check-circle");
					if(!docUploaded) {
					String salesKey=Enquiry_ACT.getSalesKey(invoiceno, token);					
					
					String message1="<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">\n"
							+ "         \n"
							+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">\n"
							+ "        \n"
							+ "                <a href=\"#\" target=\"_blank\">\n"
							+ "                <img src=\"https://corpseed.com/assets/img/logo.png\"></a>\n"
							+ "            </td></tr>\n"
							+ "            <tr>\n"
							+ "              <td style=\"text-align: center;\">\n"
							+ "                <h1>ORDER UPDATE</h1>\n"
							+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>\n"
							+ "        <tr>\n"
							+ "          <td style=\"padding:70px 0 20px;color: #353637;\">\n"
							+ "            Hi "+clientname+",</td></tr>\n"
							+ "             <tr>\n"
							+ "                    <td style=\"padding: 10px 0 15px;color: #353637;\"> \n"
							+ "                     <p> This is a courtsey mail to update you on the status of <b>"+invoiceno+"</b>. Your documents are pending that are required to process forward with the order. \n"
							+ "                      </p>\n"
							+ "                    </td></tr>  \n"						
							+ "                         <tr>\n"
							+ "                                <td style=\"padding: 15px 20px 20px;border: 15px solid #e5e5e5;text-align: center;\"> \n"
							+ "                                  <h2 style=\"text-align: center;\">Action Required</h2>\n"
							+ "                                 <p style=\"text-align: left;\">You have pending documents that are require. Your attention in order to receive you value of your purchase. \n"
							+ "                                  </p><p>These item will impact the process and can delay the filing process for your order. Please submit the require documents.</p>\n"							
							+ "                                <a href=\""+domain+"viewalldocuments-"+salesKey+".html\"><button style=\"background-color: #2b63f9 ;margin-top:15px;color:#fff;padding: 10px 30px;border: 1px solid #2b63f9;border-radius:50px\">Submit Documents</button></a>\n"
							+ "                                </td></tr>  \n"
							+ "         \n"
							+ "          \n"
							+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">\n"
							+ "                <b>Invoice/Estimate : #"+invoiceno+"</b><br>\n"
							+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p>\n"
							+ "                \n"
							+ "        \n"
							+ "    </td></tr> \n"
							+ "      \n"
							+ "    </table>";
					
					Enquiry_ACT.saveEmail(contactemail,"empty","Welcome Message | Corpseed", message1,2,token);
					}
			}	
				//if account not exist then create account
				if(accountid==null||accountid.equalsIgnoreCase("NA")){					
					status=Clientmaster_ACT.openClientAccount(invoice,clientid, clientname, addedby, token);
					if(status){
					//get account id
					accountid=Enquiry_ACT.getClientsAccountid(clientid, token);
					}
				}else if(accountid!=null&&!accountid.equalsIgnoreCase("NA")){
					String description="Payment debited againt Invoice : "+invoice;
					double orderamount=Enquiry_ACT.getBillingOrderAmount(invoiceno, token);
					//debit project price from client\"s account
					status=Clientmaster_ACT.debitSalesAmountOfClient(accountid,description,orderamount,invoice,today,addedby);
					String laserkey=RandomStringUtils.random(40, true, true);
					String remarks="NA";
					if(!clientname.equalsIgnoreCase("NA")){
						remarks="#"+invoice+" - "+clientname;
					}else{
						remarks="#"+invoice+" - .....";
					}
					//maintain laser history in manage transaction					
					Enquiry_ACT.saveInTransactionHistory(laserkey,invoice,today,contactname,contactmobile,clientname,"Sales Income",orderamount,0,token,addedby,remarks,"Sales","Sales","NA","00-00-0000");
				}
			}	
			
			
			if(amount>0||paymentMode.equalsIgnoreCase("PO")){
				//updating billing number in payment
				String unbillNo=Enquiry_ACT.getInvoiceNumber(token);
				String initial = Usermaster_ACT.getStartingCode(token,"imbillingkey");
				if (unbillNo==null||unbillNo.equalsIgnoreCase("NA") || unbillNo.equalsIgnoreCase("")) {
					unbillNo=initial+"1";
				}else {
					   String enq=unbillNo.substring(initial.length());
					   int j=Integer.parseInt(enq)+1;
					   unbillNo=initial+Integer.toString(j);
					}
				
				//if payment mode is PO insert
				if(paymentMode.equalsIgnoreCase("PO")) {
					int paymentId=Enquiry_ACT.getPaymentIdByKey(refid,token);
					boolean isPaymentIdExist=Enquiry_ACT.isPaymentInvoiceReminderExist(paymentId);
					if(!isPaymentIdExist&&paymentId>0)
						Enquiry_ACT.saveTaxInvoiceReminder(paymentId,false);				
				}
				//inserting invoice number into invoice table
				Enquiry_ACT.saveNewInvoice(unbillNo,addedby,token);
				//updating unbilled number into sales payment
				Enquiry_ACT.updateUnbillNumber(refid,token,unbillNo);
				
				String billingDoAction=(String)session.getAttribute("billingDoAction");
				if(billingDoAction==null||billingDoAction.length()<=0)billingDoAction="All";
				
				//updating billing details with invoice and reduce transaction amount and amount in paid amount
				
				if(!billingDoAction.equalsIgnoreCase("Hold")) {	
					if(!paymentMode.equalsIgnoreCase("PO"))						
						status=Enquiry_ACT.updateBillingAmount(invoiceno,amount,token);						
					else
						status=Enquiry_ACT.updateBillingAmountPo(invoiceno,token);
				}else {
					if(!paymentMode.equalsIgnoreCase("PO"))						
						status=Enquiry_ACT.updateHoldBillingAmount(invoiceno,amount,token);
					else
						status=Enquiry_ACT.updateHoldBillingAmountPo(invoiceno,token);
				}				
				int manageInvoiceId=Enquiry_ACT.findManageInvoiceId(invoiceno,token);
				if(manageInvoiceId>0) {
					Enquiry_ACT.updateInvoiceTaxAmount(manageInvoiceId,amount,token);
					boolean isDue=Enquiry_ACT.isManageInvoiceDue(manageInvoiceId);
					if(!isDue)
						Enquiry_ACT.disablePoReminder(manageInvoiceId);						
				}				
				
				//updating invoice number and approving this payment
				Enquiry_ACT.approvePaymentDetails(refid,token,today,loginuaid,comment); 
						
				
				//getting due amount by invoice
				double invoiceDueAmount=TaskMaster_ACT.getSalesDueAmount(invoiceno, token);
				//if due amount is zero and work done 100% update project status 2	
				if(invoiceDueAmount<=0)
					TaskMaster_ACT.updateProjectStatusByInvoice(invoiceno,token);
								
				if(invoice.equalsIgnoreCase("NA"))invoice=invoiceno;
				if(!paymentMode.equalsIgnoreCase("PO")&&accountid!=null&&!accountid.equalsIgnoreCase("NA")){
					String description="Payment credited Unbill No : "+unbillNo+" against invoice : "+invoice;
					//credit paid amount in client\"s account		
					Clientmaster_ACT.creditSalesAmountOfClient(accountid,description,amount,invoice,today,addedby);					
				}			
				String laserkey=RandomStringUtils.random(40, true, true);		
				String remarks="NA";
				if(!clientname.equalsIgnoreCase("NA")){
					remarks="#"+invoice+" - "+clientname;
				}else{
					remarks="#"+invoice+" - .....";
				}
				//maintain laser history in manage transaction
				if(amount>0)
				Enquiry_ACT.saveInTransactionHistory(laserkey,invoice,today,contactname,contactmobile,clientname,"Sales Income",0,amount,token,addedby,remarks,"Sales","Sales","NA","00-00-0000");
			
			String salesType=Enquiry_ACT.findSalesType(invoiceno,token);
			if(salesType==null||salesType.equalsIgnoreCase("NA"))
				salesType=Enquiry_ACT.findInvoicedSalesType(invoiceno,token);
			if(salesType.equals("1")) {
				//checking sales hierarchy done or not
				boolean hFlag=TaskMaster_ACT.isSalesHierarchyDone(invoice,token);
				if(hFlag) {
					
					//getting all sales hierarchies parent whose status is 1
					String HTask[][]=TaskMaster_ACT.getAllActiveProject(invoiceno,token);
					if(HTask!=null&&HTask.length>0) {
						double avlAmount=TaskMaster_ACT.getTotalInvoicePaid(invoiceno,token);
	//					System.out.println("Available amount="+avlAmount);
	//					double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno, token);
						double dueAmount[]=TaskMaster_ACT.getOrderDueAmount(invoiceno, token);
						
						double dispersedAmt=0;
						for(int i=0;i<HTask.length;i++) {
							int step=0;
							int count=0;
							double workPricePercentage=0;
	//						boolean isOk=true;
							//if amount due then proceed
	//						String dueAmtStatus=TaskMaster_ACT.isDispersedDueAmountDue(HTask[i][1],token);
	//						if(dueAmtStatus.equalsIgnoreCase("Yes")) {
							//check this is parent or child
	//						String Rtype=TaskMaster_ACT.getRelationType(HTask[i][1],token);
	//						if(Rtype.equalsIgnoreCase("child")) {
	//							isOk=TaskMaster_ACT.isProjectCompleted(HTask[i][1], token);
	//						}
	//						if(!isOk) {
							String workPayType=TaskMaster_ACT.getSalesWorkPayType(HTask[i][1],token);
							if(dueAmount[0]>0) {
							//System.out.println("workPayType="+workPayType);
							if(workPayType.equalsIgnoreCase("Milestone Pay")) {
								step=TaskMaster_ACT.getPaymentStep(HTask[i][1],token);
								if(step!=0)step+=1;
								count=TaskMaster_ACT.getTotalMilestones(HTask[i][1],token);
								boolean isExist=true;							
								while(isExist&&step<=count) {
									isExist=TaskMaster_ACT.getFirstStep(HTask[i][1],step,token);
									if(isExist)step+=1;								
								}
								//getting this project\"s first milestone percentage
								workPricePercentage=TaskMaster_ACT.getPricePercentage(HTask[i][1],step,token);		
								//System.out.println("step="+step);
							}else if(workPayType.equalsIgnoreCase("Partial Pay")) {workPricePercentage=50;step=0;}
							else if(workPayType.equalsIgnoreCase("Full Pay")) {workPricePercentage=100;step=0;}
							}else workPricePercentage=100;
							
							//System.out.println("workPricePercentage="+workPricePercentage);
							//getting each sales order amount
							double orderAmount=Enquiry_ACT.getProductAmount(HTask[i][1],token); 
							//System.out.println("orderAmountSales Amount="+orderAmount);
							//check if amount available then paid otherwise not
							double price=(orderAmount*workPricePercentage)/100;
							
							double dAmount=TaskMaster_ACT.getMainDispersedAmount(HTask[i][1],token);
							
							
	//						//System.out.println("Price="+price);
							if(price>dAmount) {
								price=price-dAmount;
							if(price>0&&avlAmount>=price) {
								avlAmount-=price;
								dispersedAmt+=price;
								String key=RandomStringUtils.random(40,true,true);
								String salesDetails[]=TaskMaster_ACT.getSalesData(HTask[i][1], token);
								String Dremarks=CommonHelper.withLargeIntegers(price)+" Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
								//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
								TaskMaster_ACT.saveDispersedAmount(key,HTask[i][1],salesDetails[1],salesDetails[0],salesDetails[2],today,price,Dremarks,token,addedby);
								//System.out.println("Disperced amount="+dispersedAmt);								
								
								boolean isExist=TaskMaster_ACT.isThisSaleDispersed(HTask[i][1],token);
								if(isExist) {
								//add each project's dispersed amount 
								TaskMaster_ACT.updateDisperseAmountOfSales(HTask[i][1],price,token,step);
								}else {
									//add each project's dispersed amount 
									String smwkey=RandomStringUtils.random(40,true,true);
									TaskMaster_ACT.addDisperseAmountOfSales(smwkey,HTask[i][1],salesDetails[1],salesDetails[2],price,orderAmount,token,addedby,step);
								}							
							 }else if(!paymentMode.equalsIgnoreCase("PO")) {
								 String accountant[][]=Usermaster_ACT.getAllAccountant(token);
								 String salesData[]=TaskMaster_ACT.getSalesData(HTask[i][1], token);
								if(accountant!=null&&accountant.length>0) {
									for(int j=0;j<accountant.length;j++) {										
										 //adding notification
										String nKey=RandomStringUtils.random(40,true,true);
										String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- add payment to start project work.";
										TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,token,loginuaid,"fas fa-rupee-sign");										
								}}
								//adding for sold person
								String userNKey=RandomStringUtils.random(40,true,true);
								String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- add payment to start project work.";
								TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,token,loginuaid,"fas fa-rupee-sign");
							 }
							}else if(step>0&&step<=count) {
								//System.out.println("going to update step of dispersed amount="+step);
								TaskMaster_ACT.updateDisperseAmountOfSalesStep(HTask[i][1],token,step);
							}
							String milestones[][]=TaskMaster_ACT.getAllSalesMilestone("NA", HTask[i][1], token);
							if(milestones!=null&&milestones.length>0){
								String salesStatus="NA";
								for(int k=0;k<milestones.length;k++){
								//checking task all status ok and assigned
								boolean allOk=TaskMaster_ACT.isTaskStatusOk(milestones[k][5],token);
								if(allOk){
									//set milestone start date
									boolean existFlag=TaskMaster_ACT.isDisperseExist(HTask[i][1], token); 
									double avlPrice=TaskMaster_ACT.getMainDispersedAmount(HTask[i][1], token);
									double orderAmt=TaskMaster_ACT.getSalesAmount(HTask[i][1], token);
									double percentage=Double.parseDouble(milestones[k][10]);
									double workPrice=(orderAmt*percentage)/100;
									if(avlPrice>=workPrice&&existFlag){
										String startTime=DateUtil.getCurrentTime24Hours();
										
										String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(HTask[i][1], today, milestones[i][0],token);
										String deliveryDate="NA";
										String deliveryTime="NA";
										if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
										if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
										String date=DateUtil.getCurrentDateIndianReverseFormat();
										TaskMaster_ACT.updateTaskWorkStartedDate(milestones[k][5],today,token,startTime,deliveryDate,deliveryTime,date);
	//									//System.out.println("Work started (ApproveSalesPayment)");
										//adding notification
										String nKey=RandomStringUtils.random(40,true,true);
										String milestoneData[]=TaskMaster_ACT.getAssignedMilestoneData(HTask[i][1],milestones[k][0], token);
										String message="Milestone : <span class='text-info'>"+milestoneData[0]+"</span> assigned started now,Begin your work !!.";
										TaskMaster_ACT.addNotification(nKey,today,milestoneData[1],"2","edittask-"+milestoneData[3]+".html",message,token,loginuaid,"fas fa-tasks");
										salesStatus="3";
									}else {
										salesStatus="1";
										TaskMaster_ACT.updateTaskProgressStatus(milestones[k][5],"1",token);
									}
								}
							}if(!salesStatus.equalsIgnoreCase("NA"))	
								TaskMaster_ACT.updateProjectStatus(HTask[i][1],salesStatus,token);
								
							}
							
	//						}
	//						}
						}
	//					//System.out.println("Final Disperced amount="+dispersedAmt);
						if(dispersedAmt>0) {
							//update dispersed amount in billing table
							TaskMaster_ACT.updateDispersedAmount(invoiceno,dispersedAmt,token);
						}
					}
									
				}
			}
//			System.out.println("salesType==="+salesType);
			if(salesType.equals("2")) {
				String salesKey=Enquiry_ACT.getSalesKey(invoiceno, token);
				double orderAmount=TaskMaster_ACT.findSalesAmount(invoiceno,token); 
				if(amount<orderAmount) {
					String accountant[][]=Usermaster_ACT.getAllAccountant(token);
					String salesData[]=TaskMaster_ACT.getSalesData(salesKey, token);
					if(accountant!=null&&accountant.length>0) {
						for(int j=0;j<accountant.length;j++) {							
//							System.out.println("Sending notification...................");
							 //adding notification
							String nKey=RandomStringUtils.random(40,true,true);
							String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- add payment to start project work.";
							TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,token,loginuaid,"fas fa-rupee-sign");
					}}
					//adding for sold person
					String userNKey=RandomStringUtils.random(40,true,true);
					String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- add payment to start project work.";
					TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,token,loginuaid,"fas fa-rupee-sign");
				}
				//dispersing amount
				String key=RandomStringUtils.random(40,true,true);
				String salesDetails[]=TaskMaster_ACT.getSalesData(salesKey, token);
				String Dremarks=CommonHelper.withLargeIntegers(amount)+" Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
				//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
//				System.out.println("inserting in salesworkpricectrl......");
				TaskMaster_ACT.saveDispersedAmount(key,salesKey,salesDetails[1],salesDetails[0],salesDetails[2],today,amount,Dremarks,token,addedby);
				//System.out.println("Disperced amount="+dispersedAmt);								
				
				boolean isExist=TaskMaster_ACT.isThisSaleDispersed(salesKey,token);
//				System.out.println("isExist=="+isExist);
				if(isExist) {
//					System.out.println("going to update dispersed amount....");
				//add each project's dispersed amount 
				TaskMaster_ACT.updateDisperseAmountOfSales(salesKey,amount,token,0);
				}else {
//					System.out.println("going to insert dispersed amount....");
					//add each project's dispersed amount 
					String smwkey=RandomStringUtils.random(40,true,true);
					TaskMaster_ACT.addDisperseAmountOfSales(smwkey,salesKey,salesDetails[1],salesDetails[2],amount,orderAmount,token,addedby,0);
				}
				
			}
			
			
			//adding notification
			String nKey=RandomStringUtils.random(40,true,true);			
			String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);			
			String message="Payment of rs. "+amount+" is <b class='text-success'>approved</b> against sales invoice :"+invoice+" by &nbsp;<span class='text-muted'>"+userName+"</span>";
		
			String poNumber="";
			String subject="Payment Registered | Corpseed";
			if(paymentMode.equalsIgnoreCase("PO")) {
				poNumber=Enquiry_ACT.getPONumber(refid, token);
				subject="Purchase Order Number "+poNumber+" Approved";				
				message="Purchase Order Number "+poNumber+" <b class='text-success'>approved</b> against sales invoice :"+invoice+" by &nbsp;<span class='text-muted'>"+userName+"</span>";
			}			
			
			
			StringBuffer message1=new StringBuffer("<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">"
					+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">"
					+ "                <a href=\"#\" target=\"_blank\"><img src=\"https://corpseed.com/assets/img/logo.png\"></a></td></tr>"
					+ "            <tr><td style=\"text-align: center;\">"
					+ "                <h1>ORDER UPDATE</h1>\n"
					+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>"
					+ "        <tr><td style=\"padding:70px 0 20px;color: #353637;\">"
					+ "            Hi "+clientname+",</td></tr>"
					+ "             <tr><td style=\"padding: 10px 0 15px;color: #353637;\">");
			if(paymentMode.equalsIgnoreCase("PO"))
				message1.append("<p> Purchase Order Number "+poNumber+" approved on Invoice/Estimate <b>"+invoiceno+"</b>.</p>");
			else
				message1.append("<p> Payment of Rs. <b>"+amount+"</b> added on Invoice/Estimate <b>"+invoiceno+"</b>.</p>");
					
					message1.append("</td></tr>"
					+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">"
					+ "                <b>Invoice/Estimate : #"+invoiceno+"</b><br>"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p></td></tr></table>");
			
			
			Enquiry_ACT.saveEmail(contactemail,"empty",subject, message1.toString(),2,token);
			String soldUid=Enquiry_ACT.getSalesSoldByUaid(invoiceno, token);
			String[][] user=Usermaster_ACT.getUserByID(soldUid);
			String name="";
			String email="";
			if(user!=null&&user.length>0) {
				name=user[0][5];
				email=user[0][7];
			}
			message1=new StringBuffer("<table border=\"0\" style=\"margin:0 auto; width:700px;min-width:700px;font-size:20px;line-height: 20px;border-spacing: 0;font-family: sans-serif;\">"
					+ "        <tr><td style=\"text-align: left ;background-color: #fff; padding: 15px 0; width: 50px\">"
					+ "                <a href=\"#\" target=\"_blank\"><img src=\"https://corpseed.com/assets/img/logo.png\"></a></td></tr>"
					+ "            <tr><td style=\"text-align: center;\">"
					+ "                <h1>ORDER UPDATE</h1>\n"
					+ "              <p style=\"font-size: 18px; line-height: 20px;color: #353637;\">Everything is processing well with your order.</p></td></tr>"
					+ "        <tr><td style=\"padding:70px 0 20px;color: #353637;\">"
					+ "            Hi "+name+",</td></tr>"
					+ "             <tr><td style=\"padding: 10px 0 15px;color: #353637;\">");
			if(paymentMode.equalsIgnoreCase("PO"))
				message1.append("<p> Purchase Order Number "+poNumber+" approved on Invoice/Estimate <b>"+invoiceno+"</b>.</p>");
			else
				message1.append("<p> Payment of Rs. <b>"+amount+"</b> added on Invoice/Estimate <b>"+invoiceno+"</b>.</p>");
			message1.append("</p></td></tr>"
					+ "             <tr ><td style=\"text-align: center;padding:15px;background-color:#fff;border-top: 5px solid #2b63f9;\">"
					+ "                <b>Invoice/Estimate : #"+invoiceno+"</b><br>"
					+ "                <p>Address:Corpseed, 2nd Floor, A-154A, A Block, Sector 63, Noida, Uttar Pradesh - 201301</p></td></tr></table>");
			
			if(email!=null&&email.length()>0&&!email.equalsIgnoreCase("NA"))
				Enquiry_ACT.saveEmail(email,"empty",subject, message1.toString(),2,token);
			
			String showUaid=Enquiry_ACT.getSalesSoldByUaid(invoice,token);
			TaskMaster_ACT.addNotification(nKey,today,showUaid,"2","manage-sales.html",message,token,loginuaid,"fas fa-rupee-sign");
			//adding notification for client
			String cnKey=RandomStringUtils.random(40,true,true);			
			String clmessage="Payment of rs. "+amount+" is deposited against sales invoice :"+invoice+" .";
			if(paymentMode.equalsIgnoreCase("PO"))
				clmessage="Purchase Order Number "+poNumber+" is approved against sales invoice :"+invoice+" .";
		
			String clientUaid=Clientmaster_ACT.getClientIdByKey(clientrefid,token);
			TaskMaster_ACT.addNotification(cnKey,today,clientUaid,"1","client_payments.html",clmessage,token,loginuaid,"fas fa-rupee-sign");
			
			
			//adding estimate notification
			String estremarks="<span style=\"color:#48bd44;\">Payment Updated</span>";
			if(paymentMode.equalsIgnoreCase("PO"))
				estremarks="<span style=\"color:#48bd44;\">Purchase Order "+poNumber+" Updated</span>";
			String estKey=RandomStringUtils.random(40,true,true);	
			String estimateNo=Clientmaster_ACT.getEstimateNumber(invoiceno,token);
			Clientmaster_ACT.saveEstimateNotification(estKey,estimateNo,loginuaid,estremarks,today,token);
		}
		}
		if(status){
			pw.write("pass");
		}else{
			pw.write("fail");
		}
	}catch(Exception e){e.printStackTrace();
		log.info("Error in admin.enquiry.ApproveSalesPaymentCTRL \n"+e);
	}
	
	}

}
