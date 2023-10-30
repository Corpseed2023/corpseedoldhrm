package admin.enquiry;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import com.azure.storage.blob.BlobClientBuilder;
import com.oreilly.servlet.MultipartRequest;

import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import commons.AzureBlob;
import commons.CommonHelper;
import commons.DateUtil;

@SuppressWarnings("serial")
public class RegisterPaymentAccountCTRL extends HttpServlet {

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {

			boolean status = false;
			
			PrintWriter out=response.getWriter();
						
			HttpSession session = request.getSession(); 
			
			String key =RandomStringUtils.random(40, true, true);
//			System.out.println("pid="+pid);
			String token = (String)session.getAttribute("uavalidtokenno");
			String addedby = (String)session.getAttribute("loginuID");
			String loginuaid = (String)session.getAttribute("loginuaid");
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
			String azure_path=properties.getProperty("azure_path");
			
			String imgname="NA";
			String imgpath="NA";
			MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);
			File file=m.getFile("choosefile");
			if(file!=null){
			docpath+=File.separator;
			imgname=file.getName();		
			file = new File(docpath+imgname);
			String imgkey =RandomStringUtils.random(20, true, true);
	
			imgname=imgname.replaceAll("\\s", "");		
			imgname=imgkey+"_"+imgname;
			File newFile = new File(docpath+imgname);
			file.renameTo(newFile);
			imgpath=azure_path+azure_container+File.separator+imgname;
			
			BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
	        client.connectionString(azure_key);
	        client.containerName(azure_container);
	        InputStream targetStream = new FileInputStream(newFile);
	        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
			
			targetStream.close();
			newFile.delete();
			}
			
			String paymentmode=m.getParameter("paymentmode");
			String pymtdate=m.getParameter("pymtdate");
			String transactionid=m.getParameter("transactionid");
			String amount=m.getParameter("transactionamount");
			String estinvoice=m.getParameter("estimateNoBoxId");
			String invoiceno=m.getParameter("invoiceNoBoxId");
			String clientrefid=m.getParameter("clientRefIdBoxId");
			String contactrefid=m.getParameter("contactRefIdBoxId");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String date=DateUtil.getCurrentDateIndianReverseFormat();
			
			int serviceQty=1;
			if(m.getParameter("serviceQty")!=null)serviceQty=Integer.parseInt(m.getParameter("serviceQty"));
			
			String service_Name=m.getParameter("services");
			String professional_Fee=m.getParameter("professional_Fee");
			String Government_Fee=m.getParameter("government_Fee");
			String service_Charges=m.getParameter("service_Charges");
			String other_Fee=m.getParameter("other_Fee");
			String other_Fee_remark=m.getParameter("other_Fee_remark");
			String gstApplied=m.getParameter("gstApplied");
			String accRemarks=m.getParameter("remarks");
			
			if(professional_Fee==null||professional_Fee.length()<=0)professional_Fee="0";
			if(Government_Fee==null||Government_Fee.length()<=0)Government_Fee="0";
			if(service_Charges==null||service_Charges.length()<=0)service_Charges="0";
			if(other_Fee==null||other_Fee.length()<=0)other_Fee="0";
			if(other_Fee_remark==null||other_Fee_remark.length()<=0)other_Fee_remark="NA";
			
			String clientid=Enquiry_ACT.getClientIdByRefid(clientrefid, token);
			String clientname=Clientmaster_ACT.getClientName(clientid, token);
			if(clientname==null||clientname==""||clientname.equalsIgnoreCase("NA"))clientname="NA";
			String accountid=Enquiry_ACT.getClientsAccountid(clientid, token);
			String contact[]=Enquiry_ACT.getClientContactByKey(contactrefid, token);
			String contactname="NA";
			String contactmobile="NA";
			if(contact[0]!=null&&contact[0]!="")contactname=contact[0];
			if(contact[1]!=null&&contact[1]!="")contactmobile=contact[1];
			
			if(paymentmode==""||paymentmode.length()<=0)paymentmode="Online";
			if(pymtdate==""||pymtdate.length()<=0)pymtdate=DateUtil.getCurrentDateIndianFormat1();
			if(transactionid==""||transactionid.length()<=0)transactionid="NA";
			if(amount==""||amount.length()<=0)amount="0";
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
//			System.out.println(paymentmode+"/"+pymtdate+"/"+transactionid+"/"+amount+"/"+imgname+"/"+estinvoice+"/"+invoiceno);
			
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
			//inserting invoice number into invoice table
			Enquiry_ACT.saveNewInvoice(unbillNo,addedby,token);
						
			//add payment into salesestimatepayment
			status=Enquiry_ACT.addSalesPayment(key,today,estinvoice,invoiceno,loginuaid,paymentmode,
					transactionid,amount,token,addedby,imgname,imgpath,service_Name,pinvoice,
					accRemarks,unbillNo,serviceQty);
			if(status){
				
				String typeAmount="0";
				//adding payment type in payment details table
				if(!professional_Fee.equals("0")) {
					int professionalCgst=Integer.parseInt(m.getParameter("professionalCgst"));
					int professionalSgst=Integer.parseInt(m.getParameter("professionalSgst"));
					int professionalIgst=Integer.parseInt(m.getParameter("professionalIgst"));
					if(gstApplied.equals("0")) {
						professionalCgst=0;
						professionalSgst=0;
						professionalIgst=0;
					}
					typeAmount=m.getParameter("professional_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Professional Fees",professionalCgst,professionalSgst,professionalIgst,token,date,typeAmount);
				}
				if(!Government_Fee.equals("0")) {
					int governmentCgst=Integer.parseInt(m.getParameter("governmentCgst"));
					int governmentSgst=Integer.parseInt(m.getParameter("governmentSgst"));
					int governmentIgst=Integer.parseInt(m.getParameter("governmentIgst"));
					if(gstApplied.equals("0")) {
						governmentCgst=0;
						governmentSgst=0;
						governmentIgst=0;
					}
					typeAmount=m.getParameter("government_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Government Fees",governmentCgst,governmentSgst,governmentIgst,token,date,typeAmount);
				}
				if(!service_Charges.equals("0")) {
					int serviceCgst=Integer.parseInt(m.getParameter("serviceChargeCgst"));
					int serviceSgst=Integer.parseInt(m.getParameter("serviceChargeSgst"));
					int serviceIgst=Integer.parseInt(m.getParameter("serviceChargeIgst"));
					if(gstApplied.equals("0")) {
						serviceCgst=0;
						serviceSgst=0;
						serviceIgst=0;
					}
					typeAmount=m.getParameter("service_Charges");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Service charges",serviceCgst,serviceSgst,serviceIgst,token,date,typeAmount);
				}
				if(!other_Fee.equals("0")) {
					int otherCgst=Integer.parseInt(m.getParameter("otherCgst"));
					int otherSgst=Integer.parseInt(m.getParameter("otherSgst"));
					int otherIgst=Integer.parseInt(m.getParameter("otherIgst"));
					if(gstApplied.equals("0")) {
						otherCgst=0;
						otherSgst=0;
						otherIgst=0;
					}
					typeAmount=m.getParameter("other_Fee");
					String dkey=RandomStringUtils.random(40,true,true);
					Enquiry_ACT.savePaymentDetails(dkey,key,"Other Fees("+m.getParameter("other_Fee_remark")+")",otherCgst,otherSgst,otherIgst,token,date,typeAmount);
				}
				//updating billing paid amount
				status=Enquiry_ACT.updateBillingRegisterAmount(invoiceno,Double.parseDouble(amount),token);
				int manageInvoiceId=Enquiry_ACT.findManageInvoiceId(invoiceno,token);
				if(manageInvoiceId>0) {
					//updating tax manage invoice
					Enquiry_ACT.updateInvoiceTaxAmount(manageInvoiceId,Double.parseDouble(amount),token);
					boolean isDue=Enquiry_ACT.isManageInvoiceDue(manageInvoiceId);
					if(!isDue)
						Enquiry_ACT.disablePoReminder(manageInvoiceId);	
				}
				if(accountid!=null&&!accountid.equalsIgnoreCase("NA")){
					String description="Payment credited againt Invoice : "+invoiceno;
					//credit paid amount in client's account		
					status=Clientmaster_ACT.creditSalesAmountOfClient(accountid,description,Double.parseDouble(amount),invoiceno,today,addedby);					
				}	
				
				//getting due amount by invoice
				double invoiceDueAmount=TaskMaster_ACT.getSalesDueAmount(invoiceno, token);
				//if due amount is zero and work done 100% update project status 2	
				if(invoiceDueAmount<=0)
					TaskMaster_ACT.updateProjectStatusByInvoice(invoiceno,token);
				
				
				//checking sales hierarchy done or not
				boolean hFlag=TaskMaster_ACT.isSalesHierarchyDone(invoiceno,token);
				if(hFlag) {
					
					//getting all sales hierarchies parent whose status is 1
					String HTask[][]=TaskMaster_ACT.getAllActiveProject(invoiceno,token);
					if(HTask!=null&&HTask.length>0) {
						double avlAmount=TaskMaster_ACT.getTotalInvoicePaid(invoiceno,token);
//						double orderAmount=TaskMaster_ACT.getOrderAmount(invoiceno, token);
//						System.out.println("Available amount="+avlAmount);
						double dueAmount[]=TaskMaster_ACT.getOrderDueAmount(invoiceno, token);
						
						double dispersedAmt=0;
						for(int i=0;i<HTask.length;i++) {
							int step=0;
							int count=0;
							double workPricePercentage=0;
							boolean isOk=true;
							//if amount due then proceed
							String dueAmtStatus=TaskMaster_ACT.isDispersedDueAmountDue(HTask[i][1],token);
							if(dueAmtStatus.equalsIgnoreCase("Yes")) {
							//check this is parent or child
							String Rtype=TaskMaster_ACT.getRelationType(HTask[i][1],token);
							if(Rtype.equalsIgnoreCase("child")) {
								isOk=TaskMaster_ACT.isProjectCompleted(HTask[i][1], token);
							}
							if(isOk) {
							String workPayType=TaskMaster_ACT.getSalesWorkPayType(HTask[i][1],token);
							if(dueAmount[0]>0) {
//							System.out.println("workPayType="+workPayType);
							if(workPayType.equalsIgnoreCase("Milestone Pay")) {
								step=TaskMaster_ACT.getPaymentStep(HTask[i][1],token);
								if(step!=0)step+=1;
								count=TaskMaster_ACT.getTotalMilestones(HTask[i][1],token);
								boolean isExist=true;							
								while(isExist&&step<=count) {
									isExist=TaskMaster_ACT.getFirstStep(HTask[i][1],step,token);
									if(isExist)step+=1;								
								}
								//getting this project's first milestone percentage
								workPricePercentage=TaskMaster_ACT.getPricePercentage(HTask[i][1],step,token);		
//								System.out.println("step="+step);
							}else if(workPayType.equalsIgnoreCase("Partial Pay")) {workPricePercentage=50;step=0;}
							else if(workPayType.equalsIgnoreCase("Full Pay")) {workPricePercentage=100;step=0;}
							}else workPricePercentage=100;
//							System.out.println("workPricePercentage="+workPricePercentage);
							//getting each sales order amount
							double orderAmount=Enquiry_ACT.getProductAmount(HTask[i][1],token); 
//							System.out.println("Sales Amount="+salesAmount);
							//check if amount available then paid otherwise not
							double price=(orderAmount*workPricePercentage)/100;
							
							double dAmount=TaskMaster_ACT.getMainDispersedAmount(HTask[i][1],token);
							
							
//							System.out.println("Price="+price);
							if(price>dAmount) {
								price=price-dAmount;
							if(price>0&&avlAmount>=price) {
								avlAmount-=price;
								dispersedAmt+=price;
								String dispersekey=RandomStringUtils.random(40,true,true);
								String salesDetails[]=TaskMaster_ACT.getSalesData(HTask[i][1], token);
								String Dremarks=CommonHelper.withLargeIntegers(price)+"Rs. paid to Project : "+salesDetails[1]+" - "+salesDetails[0];
								//add in dispersed amount in salesworkpricectrl table projectNo		   projectName	  invoice
								TaskMaster_ACT.saveDispersedAmount(dispersekey,HTask[i][1],salesDetails[1],salesDetails[0],salesDetails[2],today,price,Dremarks,token,addedby);
//								System.out.println("Disperced amount="+dispersedAmt);								
								
								boolean isExist=TaskMaster_ACT.isThisSaleDispersed(HTask[i][1],token);
								if(isExist) {
								//add each project's dispersed amount 
								TaskMaster_ACT.updateDisperseAmountOfSales(HTask[i][1],price,token,step);
								}else {
									//add each project's dispersed amount 
									String smwkey=RandomStringUtils.random(40,true,true);
									TaskMaster_ACT.addDisperseAmountOfSales(smwkey,HTask[i][1],salesDetails[1],salesDetails[2],price,orderAmount,token,addedby,step);
								}							
							 }else {
								 String accountant[][]=Usermaster_ACT.getAllAccountant(token);
									if(accountant!=null&&accountant.length>0) {
										for(int j=0;j<accountant.length;j++) {
											String salesData[]=TaskMaster_ACT.getSalesData(HTask[i][1], token);
											 //adding notification
											String nKey=RandomStringUtils.random(40,true,true);
											String message="Project : <span class='text-info'>"+salesData[1]+"</span> :- add payment to start project work.";
											TaskMaster_ACT.addNotification(nKey,today,accountant[j][0],"2","manage-billing.html",message,token,loginuaid,"fas fa-rupee-sign");
											//adding for sold person
											String userNKey=RandomStringUtils.random(40,true,true);
											String userMessage="Estimate No. : <span class='text-info'>"+salesData[7]+"</span> :- add payment to start project work.";
											TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-estimate.html",userMessage,token,loginuaid,"fas fa-rupee-sign");
									}}
								 }	
							}else if(step>0&&step<=count) {
//								System.out.println("going to update step of dispersed amount="+step);
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
										String deliveryData[]=TaskMaster_ACT.getTaskDeliveryDate(HTask[i][1], today, milestones[i][0],token);
										String deliveryDate="NA";
										String deliveryTime="NA";
										if(deliveryData[0]!=null)deliveryDate=deliveryData[0];
										if(deliveryData[1]!=null)deliveryTime=deliveryData[1];
										
										String startTime=DateUtil.getCurrentTime24Hours();
										TaskMaster_ACT.updateTaskWorkStartedDate(milestones[k][5],today,token,startTime,deliveryDate,deliveryTime,date);
										salesStatus="3";
									}else {
										salesStatus="1";
										TaskMaster_ACT.updateTaskProgressStatus(milestones[k][5],"1",token);
									}
								}
							}
							if(!salesStatus.equalsIgnoreCase("NA"))	
								TaskMaster_ACT.updateProjectStatus(HTask[i][1],salesStatus,token);
								
							}
							
							}
							}
						}
//						System.out.println("Final Disperced amount="+dispersedAmt);
						if(dispersedAmt>0) {
							//update dispersed amount in billing table
							TaskMaster_ACT.updateDispersedAmount(invoiceno,dispersedAmt,token);
						}
					}
									
				}
				
				//adding notification
				String nKey=RandomStringUtils.random(40,true,true);
				String userName=Usermaster_ACT.getLoginUserName(loginuaid, token);
				String showUaid=Enquiry_ACT.getSalesSoldByUaid(invoiceno,token);
				String message="Payment of rs. "+amount+" is registered against invoice no. :"+invoiceno+" by &nbsp;<span class='text-muted'>"+userName+"</span>";
				TaskMaster_ACT.addNotification(nKey,today,showUaid,"2","manage-estimate.html",message,token,loginuaid,"fas fa-rupee-sign");
				
				String laserkey=RandomStringUtils.random(40, true, true);	
				String remarks="NA";
				if(!clientname.equalsIgnoreCase("NA")){
					remarks="#"+invoiceno+" - "+clientname;
				}else{
					remarks="#"+invoiceno+" - .....";
				}
				//maintain laser history in manage transaction			name          mobile
				status=Enquiry_ACT.saveInTransactionHistory(laserkey,invoiceno,today,contactname,contactmobile,clientname,"Sales Income",0,Double.parseDouble(amount),token,addedby,remarks,"Sales","Sales","NA","00-00-0000");
			}
			if(status){
				out.write("pass");
			}else{
				out.write("fail");
			}
		}

		catch (Exception e) {
				e.printStackTrace();
		}

	}
}