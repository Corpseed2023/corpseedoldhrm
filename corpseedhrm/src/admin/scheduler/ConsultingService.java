package admin.scheduler;

import java.util.TimerTask;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.export.ExcelGenerator;
import admin.master.Usermaster_ACT;
import admin.task.TaskMaster_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;

public class ConsultingService extends TimerTask {

	@Override
	public void run() {

		//fetching all consulting sale
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		
		String service[][]=Enquiry_ACT.fetchConsultingService(today);
		if(service!=null&&service.length>0) {
			for(int i=0;i<service.length;i++) {
				
				int days=0;
				if(service[i][3].equalsIgnoreCase("Day"))
					days=Integer.parseInt(service[i][2]);
				else if(service[i][3].equalsIgnoreCase("Month"))
					days=Integer.parseInt(service[i][2])*30;
				else if(service[i][3].equalsIgnoreCase("Year"))
					days=Integer.parseInt(service[i][2])*365;				
				
				String paymentDate=DateUtil.getDateAfterDaysFromDate(days, today);
				
				//updating payment date
				boolean updateFlag=Enquiry_ACT.updatePaymentDate(paymentDate,service[i][0],service[i][14]);
//				System.out.println("updateFlag=="+updateFlag);
				if(updateFlag) {		
					
//					String salesid,String prodrefid,String pricetype,
//					double price,String hsn,double cgst,double sgst,double igst,double cgstprice,
//					double sgstprice,double igstprice,double totalprice,String refid,String token,
//					String addedby,String eskey,String minprice
					
					String price[][]=Enquiry_ACT.fetchEstimatePrice(service[i][1],service[i][14]);
					//inserting price in estimate and sales spsalesid,sppricetype,spaddedby
					if(price!=null&&price.length>0) {
						String refid=RandomStringUtils.random(40,true,true);
						Enquiry_ACT.saveSalesProductPrice(price[0][0],"NA",price[0][1],Double.parseDouble(service[i][5]),service[i][6],
								Double.parseDouble(service[i][7]),Double.parseDouble(service[i][8]),Double.parseDouble(service[i][9]),
								Double.parseDouble(service[i][10]),Double.parseDouble(service[i][11]),Double.parseDouble(service[i][12])
								,Double.parseDouble(service[i][13]),refid,service[i][14],price[0][2],service[i][1],"0");
					}
					
					price=Enquiry_ACT.fetchSalesPrice(service[i][15],service[i][14]);
					//String pricekey,String saleskey,String prodrefid,String pricetype,double price,String hsncode,
					//double cgstpercent,double sgstpercent,double igstpercent,double cgstprice,double sgstprice,
					//double igstprice,double total,String token,String addedby
					if(price!=null&&price.length>0) {
						String pricekey=RandomStringUtils.random(40, true, true);
						//insert estimate price details into project price table
						Enquiry_ACT.convertEstimatePriceToSale(pricekey,service[i][15],"NA",price[0][0],Double.parseDouble(service[i][5])
								,service[i][6],Double.parseDouble(service[i][7]),Double.parseDouble(service[i][8]),
								Double.parseDouble(service[i][9]),Double.parseDouble(service[i][10]),
								Double.parseDouble(service[i][11]),Double.parseDouble(service[i][12]),
								Double.parseDouble(service[i][13]),service[i][14],price[0][1]);
					}
					
					String salesData[]=TaskMaster_ACT.getSalesData(service[i][15], service[i][14]);
					
					//updating amount in billing
					Enquiry_ACT.updateConsultingBillingAmount(salesData[2],Double.parseDouble(service[i][13]),service[i][14]);					
				
					//sending notification to sales person
					
					String userNKey=RandomStringUtils.random(40,true,true);
					String userMessage="Invoice No. : <span class='text-info'>"+salesData[2]+"</span> :- add consulting service renewal fee.";
					TaskMaster_ACT.addNotification(userNKey,today,salesData[6],"2","manage-sales.html?inv="+salesData[2],userMessage,
							service[i][14],salesData[6],"fas fa-rupee-sign");
					
					//sending email to client : add payment
					
//					System.out.println("going to send email to client.....");
					String clientName=TaskMaster_ACT.getSalesContactName(salesData[3]);
					String clientEmail=TaskMaster_ACT.getSalesContactEmail(salesData[3]);
					String salesPersonEmail=Usermaster_ACT.findUserEmailByUaid(Integer.parseInt(salesData[6]));
					double orderDueAmount=Clientmaster_ACT.getSalesDueAmount(salesData[2], service[i][14]);
					String invoiceLink="https://crm.corpseed.com/sales-invoice-"+service[i][15]+".html";
					String message=ExcelGenerator.findClientDueMessage(clientName,orderDueAmount,salesData[2],today,invoiceLink);
					Enquiry_ACT.saveEmail(clientEmail, salesPersonEmail, "Corpseed ITES Private Limited #"+salesData[2], message, 2, service[i][14]);
				
				}
				
			}
		}
		
	}

}
