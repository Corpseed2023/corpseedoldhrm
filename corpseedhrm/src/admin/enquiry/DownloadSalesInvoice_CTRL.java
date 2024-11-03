package admin.enquiry;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.DecimalFormat;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.RandomStringUtils;
import org.apache.log4j.Logger;
import org.apache.pdfbox.util.PDFMergerUtility;

import com.itextpdf.html2pdf.ConverterProperties;
import com.itextpdf.html2pdf.HtmlConverter;

import admin.master.CloudService;
import admin.task.TaskMaster_ACT;
import commons.AzureBlob;
import commons.CommonHelper;
import commons.DateUtil;

public class DownloadSalesInvoice_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Logger log = Logger.getLogger(DownloadSalesInvoice_CTRL.class);
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		PrintWriter pw=response.getWriter();
		/* 4th code */
		try {
			HttpSession session=request.getSession();
			PDFMergerUtility obj = new PDFMergerUtility();	
			DecimalFormat df = new DecimalFormat("#.##");
			
			String token=(String)session.getAttribute("uavalidtokenno"); 
			String loginuaid = (String)session.getAttribute("loginuaid");
			String salesKey1=request.getParameter("salesKey").trim();
			
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String dest=properties.getProperty("path")+"documents"+File.separator+"invoices.pdf";			
			String path=properties.getProperty("path")+"download_invoice"+File.separator;
		
			
			String today=DateUtil.getCurrentDateIndianReverseFormat();
			String time=DateUtil.getCurrentTime();
			
			String domain=properties.getProperty("domain");
			String salesKey="";
//			System.out.println(salesKey1);
			String x[]=salesKey1.split(",");
			if(x!=null&&x.length>0) {
				for(int i=0;i<x.length;i++) {
					if(!salesKey.contains(x[i])) {
						salesKey+=x[i]+"#";
					}
				}
			}
//			System.out.println(salesKey);
			String salesInvoice[]=salesKey.split("#");
						
			if(salesInvoice!=null&&salesInvoice.length>0) {
			int inv=1;
				for (String invoice : salesInvoice) {					
					
					String billData[]=Enquiry_ACT.getSalesDataForInvoice(invoice,token);
					String client[]=Enquiry_ACT.getClientsDetail(billData[0],token);
					double orderAmount=TaskMaster_ACT.getOrderAmount(invoice,token);  
					double paidAmount=TaskMaster_ACT.getSalesPaidAmount(invoice, token);
					double dueAmount=(orderAmount-paidAmount);
										
					String billTo="";
					if(client[0]!=null){billTo=client[0];}
					String shipToAddress="";
					if(client[1]!=null){shipToAddress=client[1];}
					String shipToState="";
					if(client[2]!=null){shipToState=client[2];}
					String shipToStateCode="";
					if(client[3]!=null&&!client[3].equalsIgnoreCase("NA")){shipToStateCode="("+client[3]+")";}
					String billingDate="";
					if(billData[1]!=null){ billingDate=billData[1];}
					StringBuffer k=new StringBuffer();
				    k.append("<!DOCTYPE html><html><body style='width:700px;'>"
				    		+ "<div class='clearfix menuDv pad_box3 pad05 mb10' style='min-height: 150px;margin-top: 16px;width: 50%;margin-left: 25%;'>"
				    		+ "<div class='clearfix invoice_div'>"
				    		+ "<div class='clearfix' style='width:700px;padding-top:0px;'>"
				    		+ "<div style='width:50%;float:left;'>"
				    		+ "<div style='margin-bottom:1px;'>"
				    		+ "<img src='"+request.getContextPath()+"/staticresources/images/corpseed-logo.png' alt='corpseed logo' style='max-width:95px;'/>"
				    		+ "</div>"
				    		+ "<div class='clearfix'>"
				    		+ "<p>"
				    		+ "<span style='font-weight:600;color:#888;'>Corpseed&nbsp;Ites&nbsp;Private&nbsp;Limited</span><br>"
				    		+ "<span>CN&nbsp;U74999UP2018PTC101873</span><br>"
				    		+ "<span>2nd Floor, A-154A, A Block, Sector 63</span><br>"
				    		+ "<span>Noida, Uttar Pradesh - 201301</span><br>"
				    		+ "<span>GSTIN 09AAHCC4539J1ZC</span>"
				    		+ "<br>"
				    		+ "</p>"
				    		+ "</div>"
				    		+ "</div>"
				    		+ "<div style='width:50%;float:left;'>"
				    		+ "<div style='margin-bottom:10px;text-align:right;'>"
				    		+ "<h2 style='font-size:18px;margin:0 0 5px;color:#48bd44;font-weight: 500;'>INVOICE&nbsp;&nbsp;<span style='font-weight:600;color:black;'># "+invoice+"</span></h2>"
				    		+ "</div>");		
				    		if(dueAmount>0) {
				    		k.append("<div style='width: 100%;'>"
				    		+ "<div style='text-align:right;font-size: 14px;margin-top: 40px;font-weight: 600;'>"
				    		+ "<span>Due Amount&nbsp;&nbsp;:&nbsp;&nbsp;</span><span><i class='fa fa-inr'></i>&nbsp;"+CommonHelper.withLargeIntegers(dueAmount)+"</span>"
				    		+ "</div> "
				    		+ "</div>");
				    		}
				    		k.append("</div>"
				    		+ "</div>"
				    		+ "<div class='clear'></div>"
				    		+ "<div class='clearfix' style='width:100%;'>"
				    		+ "<span>Bill To : </span><br/>"
				    		+ "<span style='font-weight: 600;margin-bottom: 5px;'>"+billTo+"</span>"
				    		+ "</div><br/>"
				    		+ "<div class='clear'></div>"
				    		+ "<div class='clearfix' style='width:700px;'>"		    	
				    		+ "<span style='margin-bottom:5px;'>Ship To : </span><br/>"
				    		+ "<span>"+billTo+"</span>&nbsp;"
				    		+ "<span>"+shipToAddress+"</span><br/><br/>"
				    		+ "<span>Place Of Supply: <span>"+shipToState+"&nbsp;"+shipToStateCode+"</span></span>"
				    		+ "<div style='text-align:right;'><span style='font-weight:600;color:#888;'>Date :</span> <span style='padding-left:10px;'>"+billingDate+"</span></div>"		    		
				    		+ "</div>"
				    		+ "<div class='clear'></div>"
				    		+ "<div class='clearfix' style='width:700px;'>"
				    		+ "<div class='clearfix' style='width:100%;background:#48bd44 !important;padding-bottom:8px;padding-top:8px;border-radius: 3px;height:15px;'>"
				    		+ "<div style='width:4%;float:left;'>"
				    		+ "<p style='margin:0;color:#fff !important;font-size:11px;text-align:center;'>#</p>"
				    		+ "</div>"
				    		+ "<div style='width:30%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;color:#fff'>Item &amp; Description </p>"
				    		+ "</div>"
				    		+ "<div style='width:13%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;text-align: right;color:#fff;'>HSN</p>"
				    		+ "</div>"
				    		+ "<div style='width:15%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;text-align: right;color:#fff;'>Rate</p>"
				    		+ "</div>"
				    		+ "<div style='width:8%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;text-align: right;color:#fff;'>GST %</p>"
				    		+ "</div>"
				    		+ "<div style='width:12%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;text-align: right;color:#fff;'>GST Amt.</p>"
				    		+ "</div>"
				    		+ "<div style='width:18%;float:left;'>"
				    		+ "<p style='margin:0;font-size:11px;text-align: right;padding-right: 10px;color:#fff;'>Amount</p>"
				    		+ "</div>"
				    		+ "<div class='clear'></div>"
				    		+ "</div>");
				    		int totalQty=0;
				    		double totalRate=0;
				    		double totalRateSum=0;
				    		double totalGST=0;
				    		double totalAmount=0;
				    		double discount=0;
				    		String salesProductList[][]=Enquiry_ACT.getSoldSalesProductList(invoice,token);
				    		if(salesProductList!=null&&salesProductList.length>0){
				    			for(int i=0;i<salesProductList.length;i++){
				    				totalQty+=1;
				    				discount+=TaskMaster_ACT.getSalesDiscount(invoice,token);
				    				String salesPriceList[][]=Enquiry_ACT.getSalesPriceList(salesProductList[i][0],token);
				    				String border="";
				    				if(i>0)border="border-top: 1px solid #ccc;";
				    		k.append("<div class='clearfix' style='width:100%;padding-top:4px;padding-bottom:4px;'>"
				    		+ "<div class='clearfix' style='font-weight: 600;width:100%;margin-top:5px;padding-bottom:2px;margin-bottom:5px;"+border+"'>"
				    		+ "<div style='width:4%;float:left;'><span style='margin: 0; font-size: 12px;'>"+(i+1)+"</span></div>"
				    		+ "<div style='width:96%;float:left;'>"
				    		+ "<span style='font-size: 12px;'>"+salesProductList[i][1]+" (1)</span>"
				    		+ "</div>"
				    		+ "</div>");
				    		if(salesPriceList!=null&&salesPriceList.length>0){
				    			for(int j=0;j<salesPriceList.length;j++){
				    				totalRate=Double.parseDouble(salesPriceList[j][2]);
				    				totalRateSum+=totalRate;
				    				double gstPercentage=(Double.parseDouble(salesPriceList[j][4])+Double.parseDouble(salesPriceList[j][5])+Double.parseDouble(salesPriceList[j][6]));
				    				double gstAmount=(Double.parseDouble(salesPriceList[j][7])+Double.parseDouble(salesPriceList[j][8])+Double.parseDouble(salesPriceList[j][9]));
				    				totalGST+=gstAmount;
				    				totalAmount+=Double.parseDouble(salesPriceList[j][10]);
				    		k.append("<div class='clearfix' style='border-top: 1px solid #ccc;margin-top:15px;padding-top:4px;padding-bottom:4px;width:100%;font-size: 12px;'>"
				    		+ "<div style='width:4%;float:left;'>&nbsp;</div>"
				    		+ "<div style='width:30%;float:left;'>"+salesPriceList[j][1]+"</div>"		    		
				    		+ "<div style='width:13%;float:left;text-align: right;'><span>"+salesPriceList[j][3]+"</span></div>"
				    		+ "<div style='width:15%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(Double.parseDouble(salesPriceList[j][2]))+"</spanp></div>"
				    		+ "<div style='width:8%;float:left;text-align: right;'><span>"+gstPercentage+"%</span></div>"
				    		+ "<div style='width:12%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(gstAmount)+"</span></div>"
				    		+ "<div style='width:18%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(Double.parseDouble(salesPriceList[j][10]))+"&nbsp;</span></div>"
				    		+ "</div>");
				    			}}
				    		k.append("<div class='clear'></div>"
				    		+ "</div>");
				    			}}if(discount>0){
				    				
				    				k.append("<div class='clearfix' style='font-weight: 600;border-top: 1px dotted black;margin-top:20px;padding-top:2px;font-size:11px;'>"
								    		+ "<div style='width:4%;float:left;'>&nbsp;</div>"
								    		+ "	<div style='width: 30%;float:left;'><span>&nbsp;</span></div>"
								    		+ "	<div style='width:13%;float:left;text-align: right;'><span>Disc.</span></div>"
								    		+ "	<div style='width:15%;float:left;text-align: right;'><span>&nbsp;</span></div>"
								    		+ "	<div style='width:8%;float:left;text-align: right;'><span>&nbsp;</span></div>"
								    		+ "	<div style='width:12%;float:left;text-align: right;'><span>&nbsp;</span></div>"
								    		+ "	<div style='width:18%;float:left;text-align: right;'><span>-"+CommonHelper.withLargeIntegers(discount)+"</span>"
								    		+ "	</div>	"
								    		+ "</div>");
				    			}
				    			String number_str=DateUtil.amountInWords(df.format(totalAmount-discount)+"");
				    		k.append("<div class='clearfix' style='font-weight: 600;border-top: 1px dotted black;border-bottom: 1px dotted black;margin-top:15px;padding-top:4px;padding-bottom:15px;font-size:12px;'>"
				    		+ "<div style='width:4%;float:left;'>&nbsp;</div>"
				    		+ "	<div style='width: 30%;float:left;'><span>Total</span></div>"
				    		+ "	<div style='width:13%;float:left;'><span>Qty. : &nbsp;"+totalQty+"</span></div>"
				    		+ "	<div style='width:15%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(totalRateSum)+"</span></div>"
				    		+ "	<div style='width:8%;float:left;text-align: right;'><span>&nbsp;</span></div>"
				    		+ "	<div style='width:12%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(totalGST)+"</span></div>"
				    		+ "	<div style='width:18%;float:left;text-align: right;'><span>"+CommonHelper.withLargeIntegers(totalAmount-discount)+"</span>"
				    		+ "	</div>	"
				    		+ "</div>"
				    		
				    		+ "<div class='clearfix' style='width:100%;padding: 10px 0 0 0;'>"
				    		+ "<p style='margin:0;font-size:11px;padding-left:10px;padding-right:10px;text-align:right;'>Total In Words: <span style='font-weight:600;padding-left:10px;color:#666;'>"+number_str+"</span></p>"
				    		+ "</div>");
				    		String salesTaxData[][]=Enquiry_ACT.getSalesTaxList(invoice,token);
				    		if(salesTaxData!=null&&salesTaxData.length>0){
				    			k.append("<div class='clearfix' style='width: 100%'>"
					    		+ "Tax Details"
					    		+ "<div class='clearfix' style='width:700px;border: 1px dotted black;margin-top: 10px;'>"
					    		+ "    <div class='clearfix' style='width: 100%;font-weight: 600;text-align: center;border-bottom: 1px dotted black;padding-top: 4px;padding-bottom:15px;font-size: 12px;'>"
					    		+ "    	<div style='width: 25%;float:left;'>HSN</div>"
					    		+ "    	<div style='width: 25%;float:left;'>SGST %</div>"
					    		+ "    	<div style='width: 25%;float:left;'>CGST %</div>"
					    		+ "    	<div style='width: 25%;float:left;'>IGST %</div>"
					    		+ "    </div>");
				    			for(int j=0;j<salesTaxData.length;j++){
				    				String border="";
				    				if(j>0)border="border-top: 1px dotted #ccc;";
				    				k.append("<div class='clearfix taxRemoveBox' style='width: 100%;text-align: center;padding-top: 4px;padding-bottom:15px;font-size: 12px;"+border+"'>"
						    		+ "		   <div style='width: 25%;float:left;'>"+salesTaxData[j][0]+"</div>"
						    		+ "		   <div style='width: 25%;float:left;'>"+salesTaxData[j][2]+"</div>"
						    		+ "		   <div style='width: 25%;float:left;'>"+salesTaxData[j][1]+"</div>"
						    		+ "		   <div style='width: 25%;float:left;'>"+salesTaxData[j][3]+"</div>"
						    		+ "	   </div>");
				    				}	
				    		
				    		k.append("</div>"
				    		+ "</div>");
				    		}
				    		k.append("</div>"
				    		+ "<div class='clear'></div>"		    		
				    		+ "<div class='clearfix' style='width:700px;margin-top:5px;margin-bottom:5px;'>  "
				    		+ "<p style='margin-bottom:5px;color:#555;'><span style='font-weight: 600;'>Notes :</span> <span></span></p>"
				    		+ "<p style='font-size: 12px;color:#888;'>This Estimates &amp; price quotation is valid for 7 calendar days from the date of issue.</p>"
				    		+ "</div>"
				    		+ "<div class='clearfix' style='width:100%;'>"
				    		+ "<p style='color:#888;'>"
				    		+ "<span style='display:block;font-weight:600;font-size: 12px;'>Payment Options:</span>"
				    		+ "<span style='display:block;'>"
				    		+ "<span style='font-weight:600;'>IMPS/RTGS/NEFT:</span> Account Number: 10052624515 || IFSC Code: IDFB0021331 || Beneficiary Name: Corpseed ITES Private Limited || Bank Name: IDFC FIRST Bank, Noida, Sector 63 Branch</span>"
				    		+ "<span style='display:block;'><span style='font-weight:600;'>Direct Pay:</span> https://www.corpseed.com/payment || <span style='font-weight:600;'>Pay via UPI:</span> CORPSEEDV.09@cmsidfc</span>"
				    		+ "</p>"
				    		+ "</div>"
				    		+ "<div class='clearfix' style='width:700px;margin-top:5px;border-top:1px solid #ddd;padding-top:5px;margin-bottom:10px;'>"
				    		+ "<p style='color:#999;font-size: 12px;'>Note: Government fee and corpseed professional fee may differ depending on any additional changes advised the client in the application  or any changes in the government policies</p>"
				    		+ "</div>"		    		
				    		+ "</div>"
				    		+ "</div>"
				    		+ "</body></html>");
				    		
				    		String pdfFileName = Enquiry_ACT.getPdfFileName(inv);
				    		
				    		File newFile=new File(path+pdfFileName);				    		
				    		if(newFile.createNewFile()) {
				    			System.out.println("file created");
				    			OutputStream file = new FileOutputStream(new File(path+pdfFileName));
				    		    
				    		    ConverterProperties properties1 = new ConverterProperties()
			    		    		.setBaseUri(domain);
				    		    HtmlConverter.convertToPdf(k.toString(), file, properties1);
				    		    obj.addSource(new File(path+pdfFileName));
				    		}				    		
			    		    inv++;
			    		//inserting invoice download history
		    		    String key=RandomStringUtils.random(40,true,true);
		    		    Enquiry_ACT.addDownloadHistory(key,"Invoice download",invoice,"NA",today,time,loginuaid,"Sales",token);
			}
				obj.setDestinationFileName(dest);
    		    obj.mergeDocuments();
    		   
    		    Thread.sleep(5000);
    		    CloudService.deleteFileIfExist("invoices.pdf");
    	        
    	        File inv_path = new File(dest);
    			CloudService.uploadDocument(inv_path, "invoices.pdf");   		    
    		    
    		    
    		    FileUtils.cleanDirectory(new File(path)); 
			}else {pw.write("fail");}
	    		    
	    		  pw.write("pass");  
		} catch (Exception e) {
			pw.write("fail"); 
			 log.info("Download sales invoice error:-"+e.getMessage());
		    e.printStackTrace();
		    
		}	
		
	}

}
