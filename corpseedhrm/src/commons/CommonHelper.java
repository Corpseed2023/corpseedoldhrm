package commons;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URL;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.Formatter;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;

public class CommonHelper {

	private static final SimpleDateFormat format = new SimpleDateFormat("HH:mm");
	
	public static String formatValue(double value) {
		if(value!=0) {
		boolean flag=false;
//		System.out.println(value);
		if(value<0) {flag=true;value=Math.abs(value);}
//		System.out.println(value);
		int power; 
		    String suffix = " KMBT";
		    String formattedNumber = "";

		    NumberFormat formatter = new DecimalFormat("#,###.#");
		    power = (int)StrictMath.log10(value);
		    value = value/(Math.pow(10,(power/3)*3));
		    formattedNumber=formatter.format(value);
//		    System.out.println("formattedNumber="+formattedNumber);
		    formattedNumber = formattedNumber + suffix.charAt(power/3);
		    String number=formattedNumber.length()>4 ?  formattedNumber.replaceAll("\\.[0-9]+", "") : formattedNumber;
		    if(flag)number="-"+number;
		    return number; 
		}else {
			return "0"; 
		}
		    
		}
	public static double convertUptoDecimalAndRound(double amount,int point) {
			String formatedAmount = String.format("%."+point+"f", amount);
			return Math.round(Double.parseDouble(formatedAmount));
		}
	public static String withLargeIntegers(double value) {
		DecimalFormat df = new DecimalFormat("#,###.00");
		return df.format(value);
	}
	
	public static double convertUptoDecimal(double amount, int points) {
		String formatedAmount = String.format("%."+points+"f", amount);
		return Double.parseDouble(formatedAmount);
	}
	
	public static double findPercent(double amount, double percent) {
		double percentAmount = (amount * percent)/100;
		return convertUptoDecimal(percentAmount, 2);
	}
	
	public static int callPostURL(String POST_URL,String POST_PARAMS) {
		int responseCode=400;
		try {
		URL obj = new URL(POST_URL);
        HttpURLConnection httpURLConnection = (HttpURLConnection) obj.openConnection();
        httpURLConnection.setRequestMethod("POST");
        httpURLConnection.setRequestProperty("User-Agent", "Mozilla/5.0");

        // For POST only - START
        httpURLConnection.setDoOutput(true);
        OutputStream os = httpURLConnection.getOutputStream();
        os.write(POST_PARAMS.getBytes());
        os.flush();
        os.close();
        // For POST only - END

        responseCode = httpURLConnection.getResponseCode();
//        System.out.println("POST Response Code :: " + responseCode);
		}catch(Exception e) {
			e.printStackTrace();
		}
		return responseCode;
	}
	public static double twoPoints(double d) {
		Formatter formatter = new Formatter();
        formatter.format("%.2f", d);
        d=Double.parseDouble(formatter.toString());
        formatter.close();
        return d;
	}
		
	public static long[] calculateHours(String date, String time) throws ParseException {
		long[] hourMinutes=new long[2];
//		System.out.println(date+"\t"+time);
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		if(!date.equalsIgnoreCase("NA")&&!time.equalsIgnoreCase("NA")) {
			if(today.equals(date)) {
				Date d1 = format.parse(time);
				Date d2 = format.parse(DateUtil.getCurrentTime24Hours());
				long diff = d2.getTime() - d1.getTime();
				
				hourMinutes[0] = diff / (60 * 1000) % 60;
				hourMinutes[1] = diff / (60 * 60 * 1000) % 24;
			}else {
				long days = DateUtil.daysBetweenTwoDates(date, DateUtil.getCurrentDateIndianReverseFormat());
//				System.out.println("days="+days);
				long hh=(days-1)*9;
				Date d1 = format.parse(time);
				Date d2 = format.parse("18:00");
				long millicesonds = d2.getTime() - d1.getTime();
//				System.out.println("millicesonds="+millicesonds);
				d1 = format.parse("09:00");
				d2 = format.parse(DateUtil.getCurrentTime24Hours());
				millicesonds+=(d2.getTime() - d1.getTime());
				
				hourMinutes[0] = millicesonds / (60 * 1000) % 60;
				hourMinutes[1] = (millicesonds / (60 * 60 * 1000) % 24)+hh;
			}
		}
		// TODO Auto-generated method stub
		return hourMinutes;
	}
	public static String getInvoice(String token,String uaid,String uuid,String type) {
		String date=DateUtil.getCurrentDateIndianReverseFormat();		
		String today=DateUtil.getCurrentDateIndianFormat1().replace("-", "");		
		today=today.substring(0,4)+today.substring(6);
//		System.out.println("today===="+today);INV00250222008
		String invoice=Enquiry_ACT.generateInvoice(token,date,type);//INV00250222008
		
		String initial = "";
		if(type.equalsIgnoreCase("TAX"))
			initial=Usermaster_ACT.getStartingCode(token,"iminvoicekey");//INV00
		else initial=type.toUpperCase();
		
		if (invoice==null||invoice.equalsIgnoreCase("NA") || invoice.equalsIgnoreCase("")) {
			invoice=initial+today+"001";
		}else {
			   String enq=invoice.substring(initial.length()+6);
			   int j=Integer.parseInt(enq)+1;
			   
			   if(j<=9)invoice=initial+today+"00"+Integer.toString(j);
			   
			   else if(j>9&&j<=99)invoice=initial+today+"0"+Integer.toString(j);
			   
			   else if(j>99)invoice=initial+today+Integer.toString(j);
			}			
		//inserting invoice number into invoice table		
		Enquiry_ACT.saveGeneratedInvoice(uuid,invoice,uaid,token,date,type);
//		System.out.println(invoice);
		return invoice;
	}
	
	public static boolean isDatePassed(String deliveryDate,String deliveryTime,
			String dateNow,String timeNow,String deliveredDate,String deliveredTime) {
		boolean flag=false;
		try {
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
			deliveryDate=deliveryDate.substring(6)+deliveryDate.substring(2,6)+deliveryDate.substring(0,2);
			
			String date1=deliveryDate+"T"+deliveryTime;
			String date2="";
			
			if(deliveredDate.equalsIgnoreCase("NA")||deliveredTime.equalsIgnoreCase("NA"))
				date2=dateNow+"T"+timeNow;
			else
				date2=deliveredDate+"T"+deliveredTime;
			
//			System.out.println(date1+"========="+date2);
			
			Date d1 = format.parse(date1);
			Date d2 = format.parse(date2);
			
//			System.out.println(d1+"========="+d2);
			
			//in milliseconds
			long timeDifferenceMilliseconds = d2.getTime() - d1.getTime();
			if(timeDifferenceMilliseconds>0)flag=true;
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return flag;
	}
	
	
	public static String getTime(String startedDate,String startedTime,
			String deliveredDate,String deliveredTime) {
		
		String time="";	//11-03-2022
		try {
			startedDate=startedDate.substring(6)+startedDate.substring(2,6)+startedDate.substring(0,2);
			
//		System.out.println(startedDate+" "+startedTime+"#"+deliveredDate+" "+deliveredTime);
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

			String date1=startedDate+"T"+startedTime;
			String date2=deliveredDate+"T"+deliveredTime;
			
//			System.out.println(date1+"========="+date2);
			
			Date d1 = format.parse(date1);
			Date d2 = format.parse(date2);
			
//			System.out.println(d1+"========="+d2);
			
			long noOfDays=DateUtil.daysBetweenTwoDates(startedDate, deliveredDate);
//			System.out.println("noOfDays=="+noOfDays);
					
				long ms=0;
				
				if(noOfDays>1) {
					ms=format.parse(startedDate+"T18:00").getTime() - d1.getTime();
					for(int i=1;i<=noOfDays;i++) {
						String dateAfterDaysFromDate = DateUtil.getDateAfterDaysFromDate(i, startedDate);
//						System.out.println(dateAfterDaysFromDate+"==="+deliveredDate);
						boolean flag=DateUtil.isSunday(dateAfterDaysFromDate);
						if(!flag) {
							if(dateAfterDaysFromDate.equalsIgnoreCase(deliveredDate)) {
								ms+=d2.getTime()-format.parse(deliveredDate+"T09:00").getTime();
							}else {
								ms+=format.parse(dateAfterDaysFromDate+"T18:00").getTime()-format.parse(dateAfterDaysFromDate+"T09:00").getTime();
							}
						}
					}
				}else if(noOfDays==1){
					ms=format.parse(startedDate+"T18:00").getTime() - d1.getTime();					
					ms+=d2.getTime() - format.parse(deliveredDate+"T09:00").getTime();
				}else {					
					ms=d2.getTime() - d1.getTime();
				}
				long timeDifferenceMilliseconds=ms;
//				System.out.println("timeDifferenceMilliseconds2=="+timeDifferenceMilliseconds);	
			
			    long diffHours = timeDifferenceMilliseconds / (60 * 60 * 1000);
			    timeDifferenceMilliseconds-=(diffHours*(60 * 60 * 1000));
			    long diffMinutes = timeDifferenceMilliseconds / (60 * 1000);
//			    System.out.println("diffMinutes=="+diffMinutes);
			    if(diffHours>=9) {
			    	long day=diffHours/9;
//			    	System.out.println("hour=="+diffHours);
			    	diffHours%=9;
//			    	System.out.println("day=="+day+"/hour=="+diffHours);
			    	time+=day+"d ";
			    }
			    if(diffHours>0)time+=diffHours+"h ";
			    if(diffMinutes>0)time+=diffMinutes+"m";
			    	    
		    
		}catch(Exception e) {
			e.printStackTrace();
		}
//		System.out.println("time==="+time);
		
		return time;
	}
	
//	public static long getBlobSize(String fileName,String azure_key,String azure_container) {
//		try {
//		BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
//		return client.blobName(fileName).buildClient().getProperties().getBlobSize();
//		}catch (Exception e) {
//			e.printStackTrace();
//			return 0;
//		}
//	}
	
	public static long getBlobSize(String fileName) {
		return 1024;
	}
	
	/*
	 * public static boolean isFileExists(String fileName,String azure_key,String
	 * azure_container) { try { BlobClientBuilder
	 * client=AzureBlob.getBlobClient(azure_key, azure_container); return
	 * client.blobName(fileName).buildClient().exists(); } catch (Exception e) {
	 * e.printStackTrace(); return false; }
	 * 
	 * }
	 */
	public static boolean isFileExists(String fileName) {
		return true;		
	}
//	public static void deleteAzureFile(String docName,String azure_key,String azure_container) {
//		BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
//		client.blobName(docName).buildClient().delete();
//	}
	public static String calculateTime(String startDate, String startTime, String deliveryDate, String deliveryTime) {
//		System.out.println("Start Date : "+startDate+"\tStart Time : "+startTime+"\tDelivery date : "+deliveryDate+"\t"
//				+ "Delivery Time : "+deliveryTime);
		String result="";
		if(startDate.equals("NA")||startTime.equals("NA"))
			return "Not Started";
		
		try {
		long month=0;
		long day=0;
		long hours=0;
		long minutes=0;
			if(startDate.equals(deliveryDate)) {
				Date d1 = format.parse(startTime);
				Date d2 = format.parse(deliveryTime);
				long diff = d2.getTime() - d1.getTime();
				
				minutes = diff / (60 * 1000) % 60;
				hours = diff / (60 * 60 * 1000) % 24;
			}else {
				long days = DateUtil.daysBetweenTwoDates(startDate, deliveryDate);
//				System.out.println("days="+days);
				long hh=(days-1)*9;
				Date d1 = format.parse(startTime);
				Date d2 = format.parse("18:00");
				long millicesonds = d2.getTime() - d1.getTime();
//					System.out.println("millicesonds="+millicesonds);
				d1 = format.parse("09:00");
				d2 = format.parse(deliveryTime);
				millicesonds+=(d2.getTime() - d1.getTime());
				
				minutes = millicesonds / (60 * 1000) % 60;
				hours = (millicesonds / (60 * 60 * 1000) % 24)+hh;
			}
		
//		System.out.println("hours=="+hours+"\tminutes="+minutes);
		
		month=(hours/9)>30?(hours/9)/30:0;
		day=month>0?(hours/9)%30:hours/9;
		hours=day>0?hours%9:hours;
		
		result=month>0?month>1?month+" Months":month+" Month":"";
		result+=day>0?month>0?day>1?" : "+day+" Days":" : "+day+" Day":day>1?day+" Days":day+" Day":"";
		result+=hours>0?day>0?hours>1?" : "+hours+" Hours":" : "+hours+" Hour":hours>1?hours+" Hours":hours+" Hour":"";
		result+=minutes>0?hours>0?minutes>1?" : "+minutes+" Minutes":" : "+minutes+" Minute":minutes>1?minutes+" Minutes":minutes+" Minute":"";
		
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
		
	}
	
	public static List<String> getCurrectIp(){
		 try {
			 List<String> currentIp = Collections.list(NetworkInterface.getNetworkInterfaces()).stream()
	                    .filter(iface -> iface.getDisplayName().toLowerCase().contains("wi-fi") ||
	                            iface.getDisplayName().toLowerCase().contains("wireless"))
	                    .flatMap(iface -> Collections.list(iface.getInetAddresses()).stream())
	                    .filter(inetAddress -> !inetAddress.isLoopbackAddress() &&
	                            inetAddress instanceof java.net.Inet6Address &&
	                            !inetAddress.getHostAddress().startsWith("fe80:"))
	                    .map(ip->ip.getHostAddress())
	                    .collect(Collectors.toList());
			 

			 
			 System.out.println(currentIp+"My IP");
			 
			 return currentIp;

	        } catch (SocketException e) {
	            e.printStackTrace();
	            return Collections.emptyList();
	        }
	}
	
	 public static String getExternalIP(HttpServletRequest request) {

//		 System.out.println("External Ip is"+ request.getRemoteAddr() );
		 return Objects.nonNull(request) ? request.getRemoteAddr() : "0";
	 }
		
}
