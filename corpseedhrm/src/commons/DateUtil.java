package commons;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.TimeZone;
import java.util.concurrent.TimeUnit;

import admin.task.TaskMaster_ACT;

public class DateUtil {

	private static final SimpleDateFormat DATE_FORMAT_INDIA = new SimpleDateFormat("dd-MMM-yy");
	private static final SimpleDateFormat TIMESTAMP_FORMAT = new SimpleDateFormat("hh:mm a");
	private static final SimpleDateFormat DATE_FORMAT_INDIA1 = new SimpleDateFormat("dd-MM-yyyy");
	private static final SimpleDateFormat DATE_FORMAT_INDIA2 = new SimpleDateFormat("ddMMyyyyhhmmss");
	private static final SimpleDateFormat DATETIME_FORMAT = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	private static final SimpleDateFormat DATE_FORMAT_INDIA3 = new SimpleDateFormat("yyyy-MM-dd");
	private static final SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");

	public static String[] getLastDate(String startDate,int TotalDay,int totalMinutes) {
		String data[]=new String[2];
		String deliveryDate="";			
//			start
		SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
	    Calendar c1 = Calendar.getInstance();
	  	int year=Integer.parseInt(startDate.substring(6, 10));
//	  	System.out.println("year="+year);
	  	int month=Integer.parseInt(startDate.substring(3, 5));
//	  	System.out.println("month="+month);
	  	int days=Integer.parseInt(startDate.substring(0, 2));
	  	days+=TotalDay;
	  	
	  	if(totalMinutes>=480) {
	  		days+=totalMinutes/480;
	  		totalMinutes=totalMinutes%480;
	    }
	  	
	  	c1.add(Calendar.MINUTE, totalMinutes);
		int dhours=c1.get(Calendar.HOUR_OF_DAY);
		int dminutes=c1.get(Calendar.MINUTE);
		int extraminute=0;
	    
	    if(dhours>=18) {
	    	TotalDay+=1;
	    	c1.set(year, (month) - 1, 1, 9, 0);
	    	extraminute=((dhours-18)*60)+dminutes;
	    	c1.add(Calendar.MINUTE, extraminute);
	    	dhours=c1.get(Calendar.HOUR_OF_DAY);
			dminutes=c1.get(Calendar.MINUTE);
	    }
	    String hh=dhours+"";
	    String mm=dminutes+"";
	    if(hh.length()==1)hh="0"+hh;
	    if(mm.length()==1)mm="0"+mm;
	    
	    String deliveryTime=hh+":"+mm;
	    c1 = Calendar.getInstance();
	  	
//	  	System.out.println("days="+days);
	    c1.set(year, (month)-1 , (days)); 		    
	    deliveryDate=sdf.format(c1.getTime());
//	    System.out.println("deliveryDate="+deliveryDate);
	    boolean flag=TaskMaster_ACT.isSunday(deliveryDate);
	    if(flag){
	    	year=Integer.parseInt(deliveryDate.substring(6, 10));
	    	month=Integer.parseInt(deliveryDate.substring(3, 5));
	    	days=Integer.parseInt(deliveryDate.substring(0, 2))+1;
//	    	System.out.println(year+"/"+month+"/"+days);
	    	c1.set(year, (month)-1 , (days)); 		    
		    deliveryDate=sdf.format(c1.getTime());
		    		    
	    }  
	    
	    data[0]=deliveryDate;
	    data[1]=deliveryTime;
	    
	    return data;
	}
	
	public static boolean isSunday(String date) {
		boolean flag = false;
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		try {
			Date d1 = formatter.parse(date);
			Calendar c1 = Calendar.getInstance();
			c1.setTime(d1);
			if (c1.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
				flag = true;
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return flag;
	}
	
	public static long getDaysBetweenTwoDates(String dateBeforeString,String dateAfterString){
		long daysBetween=0;
		SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");
//		 System.out.println(dateBeforeString+"/"+dateAfterString);
		 try {
		       Date dateBefore = myFormat.parse(dateBeforeString);
		       Date dateAfter = myFormat.parse(dateAfterString);
//		       System.out.println(dateBefore+"/"+dateAfter);
		       long difference = dateAfter.getTime() - dateBefore.getTime();
		       daysBetween = (difference / (1000*60*60*24));
	              
//		       System.out.println("Number of Days between dates: "+daysBetween);
		 } catch (Exception e) {
		       e.printStackTrace();
		 }
		 return daysBetween;
	}
	public static long daysBetweenTwoDates(String dateBeforeString,String dateAfterString){
		long daysBetween=0;
		SimpleDateFormat myFormat = new SimpleDateFormat("yyyy-MM-dd");
//		 System.out.println(dateBeforeString+"/"+dateAfterString);
		 try {
		       Date dateBefore = myFormat.parse(dateBeforeString);
		       Date dateAfter = myFormat.parse(dateAfterString);
//		       System.out.println(dateBefore+"/"+dateAfter);
		       long difference = dateAfter.getTime() - dateBefore.getTime();
		       daysBetween = (difference / (1000*60*60*24));
	              
//		       System.out.println("Number of Days between dates: "+daysBetween);
		 } catch (Exception e) {
		       e.printStackTrace();
		 }
		 return daysBetween;
	}
	public static String getPrevDaysDate(int days){
		String dueudate="NA";
		 Date date = new Date();
		 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		 Calendar c1 = Calendar.getInstance();
		 String currentdate = df.format(date);

		 try {
		     c1.setTime(df.parse(currentdate));
//		     System.out.println(currentdate);
		     c1.add(Calendar.DAY_OF_MONTH, -days);
		     df = new SimpleDateFormat("yyyy-MM-dd");
		     Date resultdate = new Date(c1.getTimeInMillis());
		     dueudate = df.format(resultdate);
//		     System.out.println(dueudate);
		 } catch (Exception e) {
		     e.printStackTrace();
		 }
		 return dueudate;
	}

	public static String getPrev2DaysDate(){
		String dueudate="NA";
		 Date date = new Date();
		 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		 Calendar c1 = Calendar.getInstance();
		 String currentdate = df.format(date);

		 try {
		     c1.setTime(df.parse(currentdate));
//		     System.out.println(currentdate);
		     c1.add(Calendar.DAY_OF_MONTH, -2);
		     df = new SimpleDateFormat("yyyy-MM-dd");
		     Date resultdate = new Date(c1.getTimeInMillis());
		     dueudate = df.format(resultdate);
//		     System.out.println(dueudate);
		 } catch (Exception e) {
		     e.printStackTrace();
		 }
		 return dueudate;
	}
	
	public static String getDateAfterDays(int days){
		String futureDate="NA";
		 Date date = new Date();
		 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		 Calendar c1 = Calendar.getInstance();
		 String currentdate = df.format(date);

		 try {
		     c1.setTime(df.parse(currentdate));
		     c1.add(Calendar.DAY_OF_MONTH, days);
		     df = new SimpleDateFormat("yyyy-MM-dd");
		     Date resultdate = new Date(c1.getTimeInMillis());
		     futureDate = df.format(resultdate);
		 } catch (Exception e) {
		     e.printStackTrace();
		 }
		 return futureDate;
	}
	
	public static String[] findPreviousWeekStartEndDate() {
		// Calendar object
		Calendar cal = Calendar.getInstance();

		// "move" cal to monday this week (i understand it this way)
		cal.set(Calendar.DAY_OF_WEEK, Calendar.SUNDAY);

		// calculate monday week ago (moves cal 7 days back)
		cal.add(Calendar.DATE, -7);
		Date firstDateOfPreviousWeek = cal.getTime();

		// calculate sunday last week (moves cal 6 days fwd)
		cal.add(Calendar.DATE, 7);
		Date lastDateOfPreviousWeek = cal.getTime();		
		
		return new String[] {new SimpleDateFormat("yyyy-MM-dd").format(firstDateOfPreviousWeek),
				new SimpleDateFormat("yyyy-MM-dd").format(lastDateOfPreviousWeek)};
	}
	
	public static String getDateAfterDaysFromDate(int days,String date){
		String futureDate="NA";
//		 Date date = new Date();
		 SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		 Calendar c1 = Calendar.getInstance();	 

		 try {
			 String currentdate = df.format(df.parse(date));
		     c1.setTime(df.parse(currentdate));
		     c1.add(Calendar.DAY_OF_MONTH, days);
		     df = new SimpleDateFormat("yyyy-MM-dd");
		     Date resultdate = new Date(c1.getTimeInMillis());
		     futureDate = df.format(resultdate);
		 } catch (Exception e) {
		     e.printStackTrace();
		 }
		 return futureDate;
	}
	
	public static String getHoursMinutes(String oldDateTime){	
//		System.out.println("=================="+oldDateTime);
		String time="NA";
		String today=getCurrentDateIndianFormat1();		
			String startDate=oldDateTime.substring(0,10).trim();		
			String startTime=oldDateTime.substring(11,16).trim();	
			String st=oldDateTime.substring(17,19);
//			System.out.println("startDate="+startDate+"/startTime="+startTime+"/st="+st);
			String end=getCurrentTime();	
			String tm=end.substring(6,8).trim();
			end=end.substring(0,5).trim();
//			System.out.println("end="+end+"/tm="+tm+"/end="+end);
			String e[]=end.split(":");
			int ehh=Integer.parseInt(e[0]);
			int emm=Integer.parseInt(e[1]);
			
			if(tm.equalsIgnoreCase("PM")&&st.equalsIgnoreCase("AM"))ehh+=12;
			
			String dateStart = startDate+" "+startTime;
			String dateStop = today+" "+ehh+":"+emm;	
		
			
//			System.out.println("dateStart="+dateStart+"/dateStop="+dateStop);
			
			SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy hh:mm");

			Date d1 = null;
			Date d2 = null;
			
			try {
				d1 = format.parse(dateStart);
				d2 = format.parse(dateStop);

				//in milliseconds
				long diff = d2.getTime() - d1.getTime();
				time = friendlyTimeDiff(diff);

			} catch (Exception ex) {
				ex.printStackTrace();
			}						
		
		return time;
	}
	public static String friendlyTimeDiff(long timeDifferenceMilliseconds) {
	    long diffSeconds = timeDifferenceMilliseconds / 1000;
	    long diffMinutes = timeDifferenceMilliseconds / (60 * 1000);
	    long diffHours = timeDifferenceMilliseconds / (60 * 60 * 1000);
	    long diffDays = timeDifferenceMilliseconds / (60 * 60 * 1000 * 24);
	    long diffWeeks = timeDifferenceMilliseconds / (60 * 60 * 1000 * 24 * 7);
	    long diffMonths = (long) (timeDifferenceMilliseconds / (60 * 60 * 1000 * 24 * 30.41666666));
	    long diffYears = timeDifferenceMilliseconds / ((long)60 * 60 * 1000 * 24 * 365);

	    if (diffSeconds < 1) {
	        return "Just Now";
	    }else if (diffSeconds == 1) {
	        return "1 second ago";
	    } else if (diffMinutes < 1) {
	        return diffSeconds + " seconds ago";
	        
	        
	        
	    }else if (diffMinutes == 1) {
	        return "1 minute ago";
	    } else if (diffHours < 1) {
	        return diffMinutes + " minutes ago";
	        
	        
	        
	    }else if (diffHours == 1) {
	        return "1 hour ago";
	    } else if (diffDays < 1) {
	        return diffHours + " hours ago";
	        
	        
	    }else if (diffDays == 1) {
	        return "1 day ago";
	    } else if (diffWeeks < 1) {
	        return diffDays + " days ago";
	        
	        
	    }else if (diffWeeks == 1) {
	        return "1 week ago";
	    } else if (diffMonths < 1) {
	        return diffWeeks + " weeks ago";
	        
	        
	    }else if (diffMonths == 1) {
		        return "1 month ago";   
	    } else if (diffYears < 1) {
	        return diffMonths + " months ago";
	        
	        
	    } else if (diffYears ==1) {
	        return "1 year ago";   
	    } else {
	        return diffYears + " years ago";
	    }
	}
	public static String getCurrentDateIndianFormat() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = DATE_FORMAT_INDIA.format(cal.getTime());
		return CurrentDate;
	}
	
	public static String getCurrentDateIndianReverseFormat() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA3.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = DATE_FORMAT_INDIA3.format(cal.getTime());
		return CurrentDate;
	}
	
	public static String getCurrentDateIndianFormat1() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = DATE_FORMAT_INDIA1.format(cal.getTime());
		return CurrentDate;
	}

	public static String getCurrentDateIndianFormat2() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = DATE_FORMAT_INDIA2.format(cal.getTime());
		return CurrentDate;
	}

	public static String getCurrentTime() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = TIMESTAMP_FORMAT.format(cal.getTime());
		return CurrentDate;
	}

	public static String getCurrentDateTime() {
		String CurrentDate = null;
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		CurrentDate = DATETIME_FORMAT.format(cal.getTime());
		return CurrentDate;
	}

	public static String get30Date() {
		Calendar cal = Calendar.getInstance();
		DATE_FORMAT_INDIA.setTimeZone(TimeZone.getTimeZone("IST"));
		cal.add(Calendar.DATE, -29);
		return TIMESTAMP_FORMAT.format(cal.getTime());
	}

	public static String[] getPrevious3MonthName(int month) {
		String months[]=new String[3];
		if(month==1) {
			months[0]="November";
			months[1]="December";
			months[2]="January";
		}else if(month==2) {
			months[0]="December";
			months[1]="January";
			months[2]="February";
		}else if(month==3) {
			months[0]="January";
			months[1]="February";
			months[2]="March";
		}else if(month==4) {
			months[0]="February";
			months[1]="March";
			months[2]="April";
		}else if(month==5) {
			months[0]="March";
			months[1]="April";
			months[2]="May";
		}else if(month==6) {
			months[0]="April";
			months[1]="May";
			months[2]="June";
		}else if(month==7) {
			months[0]="May";
			months[1]="June";
			months[2]="July";
		}else if(month==8) {
			months[0]="June";
			months[1]="July";
			months[2]="August";
		}else if(month==9) {
			months[0]="July";
			months[1]="August";
			months[2]="September";
		}else if(month==10) {
			months[0]="August";
			months[1]="September";
			months[2]="October";
		}else if(month==11) {
			months[0]="September";
			months[1]="October";
			months[2]="November";
		}else if(month==12) {
			months[0]="October";
			months[1]="November";
			months[2]="December";
		}
		return months;
	}
	public static String[] getPrevious6MonthName(int month) {
		String months[]=new String[6];
		if(month==1) {
			months[0]="Aug";
			months[1]="Sep";
			months[2]="Oct";
			months[3]="Nov";
			months[4]="Dec";
			months[5]="Jan";
		}else if(month==2) {
			months[0]="Sep";
			months[1]="Oct";
			months[2]="Nov";
			months[3]="Dec";
			months[4]="Jan";
			months[5]="Feb";
		}else if(month==3) {			
			months[0]="Oct";
			months[1]="Nov";
			months[2]="Dec";
			months[3]="Jan";
			months[4]="Feb";
			months[5]="Mar";
		}else if(month==4) {			
			months[0]="Nov";
			months[1]="Dec";
			months[2]="Jan";
			months[3]="Feb";
			months[4]="Mar";
			months[5]="Apr";
		}else if(month==5) {			
			months[0]="Dec";
			months[1]="Jan";
			months[2]="Feb";
			months[3]="Mar";
			months[4]="Apr";
			months[5]="May";
		}else if(month==6) {			
			months[0]="Jan";
			months[1]="Feb";
			months[2]="Mar";
			months[3]="Apr";
			months[4]="May";
			months[5]="Jun";
		}else if(month==7) {			
			months[0]="Feb";
			months[1]="Mar";
			months[2]="Apr";
			months[3]="May";
			months[4]="Jun";
			months[5]="Jul";
		}else if(month==8) {			
			months[0]="Mar";
			months[1]="Apr";
			months[2]="May";
			months[3]="Jun";
			months[4]="Jul";
			months[5]="Aug";
		}else if(month==9) {			
			months[0]="Apr";
			months[1]="May";
			months[2]="Jun";
			months[3]="Jul";
			months[4]="Aug";
			months[5]="Sep";
		}else if(month==10) {			
			months[0]="May";
			months[1]="Jun";
			months[2]="Jul";
			months[3]="Aug";
			months[4]="Sep";
			months[5]="Oct";
		}else if(month==11) {			
			months[0]="Jun";
			months[1]="Jul";
			months[2]="Aug";
			months[3]="Sep";
			months[4]="Oct";
			months[5]="Nov";
		}else if(month==12) {			
			months[0]="Jul";
			months[1]="Aug";
			months[2]="Sep";
			months[3]="Oct";
			months[4]="Nov";
			months[5]="Dec";
		}
		return months;
	}
	public static String[] getMonthEndDate(String[] months) {
		String monthDate[]=new String[3];
		String year=getCurrentDateIndianReverseFormat().substring(0, 4);
		if(months!=null) {
			for(int i=0;i<months.length;i++) {
				switch(months[i]) {
				case "January":
					monthDate[i]=year+"-01-31";
					break;
				case "February":
					monthDate[i]=year+"-02-28";
					break;
				case "March":
					monthDate[i]=year+"-03-31";
					break;
				case "April":
					monthDate[i]=year+"-04-30";
					break;
				case "May":
					monthDate[i]=year+"-05-31";
					break;
				case "June":
					monthDate[i]=year+"-06-30";
					break;
				case "July":
					monthDate[i]=year+"-07-31";
					break;
				case "August":
					monthDate[i]=year+"-08-31";
					break;
				case "September":
					monthDate[i]=year+"-09-30";
					break;
				case "October":
					monthDate[i]=year+"-10-31";
					break;
				case "November":
					monthDate[i]=year+"-11-30";
					break;
				case "December":
					monthDate[i]=year+"-12-31";
					break;
				}
			}
		}
		
		return monthDate;
	}
	public static String[] get6MonthEndDate(String[] months) {
		String monthDate[]=new String[6];
		String year=getCurrentDateIndianReverseFormat().substring(0, 4);
		if(months!=null) {
			for(int i=0;i<months.length;i++) {
				switch(months[i]) {
				case "Jan":
					monthDate[i]=year+"-01-31";
					break;
				case "Feb":
					monthDate[i]=year+"-02-28";
					break;
				case "Mar":
					monthDate[i]=year+"-03-31";
					break;
				case "Apr":
					monthDate[i]=year+"-04-30";
					break;
				case "May":
					monthDate[i]=year+"-05-31";
					break;
				case "Jun":
					monthDate[i]=year+"-06-30";
					break;
				case "Jul":
					monthDate[i]=year+"-07-31";
					break;
				case "Aug":
					monthDate[i]=year+"-08-31";
					break;
				case "Sep":
					monthDate[i]=year+"-09-30";
					break;
				case "Oct":
					monthDate[i]=year+"-10-31";
					break;
				case "Nov":
					monthDate[i]=year+"-11-30";
					break;
				case "Dec":
					monthDate[i]=year+"-12-31";
					break;
				}
			}
		}
		
		return monthDate;
	}	
	public static String amountInWords(String number_str) {
		String inWords="";
		if(!number_str.contains("."))
		inWords= NumberToWord(number_str) ;
		else {			
			inWords=NumberToWord(number_str.substring(0,number_str.indexOf("."))) ;
			inWords+=" rupees and "+NumberToWord(number_str.substring(number_str.indexOf(".")+1))+" paise";
		}
        if (inWords.trim().length()==0) {inWords="Zero";}
        inWords=inWords + " Only.";
                 
        return inWords;
	}
	 private static String NumberToWord (String number)
     {
     String twodigitword="";
     String word="";
     String[] HTLC = {"", "Hundred", "Thousand", "Lakh", "Crore"}; //H-hundread , T-Thousand, ..
     int split[]={0,2, 3, 5, 7,9};
     String[] temp=new String[split.length];
     boolean addzero=true;
     int len1=number.length();
     if (len1>split[split.length-1]) { System.out.println("Error. Maximum Allowed digits "+ split[split.length-1]);
     System.exit(0);
     }
     for (int l=1 ; l<split.length; l++ )
     if (number.length()==split[l] ) addzero=false;
     if (addzero==true) number="0"+number;
     int len=number.length();
     int j=0;
     //spliting & putting numbers in temp array.
     while (split[j]<len)
     {
         int beg=len-split[j+1];
         int end=beg+split[j+1]-split[j];
         temp[j]=number.substring(beg , end);
         j=j+1;
     }
      
     for (int k=0;k<j;k++)
     {
         twodigitword=ConvertOnesTwos(temp[k]);
         if (k>=1){
         if (twodigitword.trim().length()!=0) word=twodigitword+" " +HTLC[k] +" "+word;
         }
         else word=twodigitword ;
         }
        return (word);
     }

private static String ConvertOnesTwos(String t){
	 final String[] ones ={"", "One", "Two", "Three", "Four", "Five","Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve","Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"};
	 final String[] tens = {"", "Ten", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty","Ninety"};
	
	String word="";
	int num=Integer.parseInt(t);
	if (num%10==0) word=tens[num/10]+" "+word ;
	else if (num<20) word=ones[num]+" "+word ;
	else
	{
	 word=tens[(num-(num%10))/10]+word ;
	 word=word+" "+ones[num%10] ;
	}
	return word;
	}

public String timeBetweenDates(String first) {
	SimpleDateFormat dtf = new SimpleDateFormat("dd MM yyyy");
	long daysBetween=0;
	String time="Today";		   
    String last=getCurrentDateIndianReverseFormat();
    try {
    	first=first.substring(8, 10)+" "+first.substring(5, 7)+" "+first.substring(0, 4);
    	last=last.substring(8, 10)+" "+last.substring(5, 7)+" "+last.substring(0, 4);
    	
        Date date1 = dtf.parse(first);
        Date date2 = dtf.parse(last);
        long diff = date2.getTime() - date1.getTime();
        daysBetween=TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
    } catch (Exception e) {
        e.printStackTrace();
    }
    if(daysBetween>=365) {
    	long year=daysBetween/365;
    	if(year>1) {
    		time=year+" Years ago";
    	}else {
    		time=year+" Year ago";
    	}
    	
    }else if(daysBetween>=30) {
    	long month=daysBetween/30;
    	if(month>1) {
    		time=month+" Months ago";
    	}else {
    		time=month+" Month ago";
    	}
    }else {
    	if(daysBetween>1) {
    		time=daysBetween+" Days ago";
    	}else if(daysBetween==1) {
    		time="Yesterday";
    	}else if(daysBetween==0){
    		time="Today";
    	}
    }
    
	return time;
}

public static String getCurrentTime12Hours() {
	DateFormat dateFormat = new SimpleDateFormat("hh:mm a");
	String Time=dateFormat.format(new Date());
	if(Time.startsWith("0"))
		return Time.substring(1);
	else
	return Time;
}
public static String getCurrentTime24Hours() {
	return sdf.format(new Date());
}

public static String getTimeAfterMinutes(int minute) {
	// TODO Auto-generated method stub
	Calendar c1 = Calendar.getInstance();
	c1.add(Calendar.MINUTE, minute);
	int dhours=c1.get(Calendar.HOUR_OF_DAY);
	int dminutes=c1.get(Calendar.MINUTE);
	
    String timehh=dhours+"";
    String timemm=dminutes+"";
	if(timehh.length()==1)timehh="0"+timehh;
	if(timemm.length()==1)timemm="0"+timemm;
    
	return timehh+":"+timemm;
}

public static String findPreviousMonthEndDate(int previous) {
	Calendar cal = Calendar.getInstance();
    cal.add(Calendar.MONTH, -previous);
    cal.set(Calendar.DAY_OF_MONTH, cal.getActualMaximum(Calendar.DAY_OF_MONTH));

    String yy = cal.get(Calendar.YEAR)+"";
    String mm= (cal.get(Calendar.MONTH)+1)+"";
    if(mm.length()==1)mm="0"+mm;
    String dd= cal.get(Calendar.DAY_OF_MONTH)+"";
    if(dd.length()==1)dd="0"+dd;
    
    return yy+"-"+mm+"-"+dd;
}

public static int[] calculateTimeDayHour(String value, String type) {
	int time[]=new int[2];
	
	if(type.equalsIgnoreCase("Minute")) {
		time[1]=Integer.parseInt(value);
	}else if(type.equalsIgnoreCase("Hour")) {
		time[1]=Integer.parseInt(value)*60;
	}else if(type.equalsIgnoreCase("Day")) {
		time[0]=Integer.parseInt(value);
	}else if(type.equalsIgnoreCase("Week")) {
		time[0]=Integer.parseInt(value)*7;
	}else if(type.equalsIgnoreCase("Month")) {
		time[0]=Integer.parseInt(value)*30;
	}else if(type.equalsIgnoreCase("Year")) {
		time[0]=Integer.parseInt(value)*365;
	}
	return time;
}

public static String getMonthName(String month) {
	switch(month) {
		
		case "01" :return "Jan";
		
		case "02" :return "Feb";
		
		case "03" :return "Mar";
		
		case "04" :return "Apr";
		
		case "05" :return "May";
		
		case "06" :return "Jun";
		
		case "07" :return "Jul";
		
		case "08" :return "Aug";
		
		case "09" :return "Sep";
		
		case "10" :return "Oct";
		
		case "11" :return "Nov";
		
		case "12" :return "Dec";
		
		default : return "NA";
	
	}
}

}