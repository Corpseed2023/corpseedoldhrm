package admin.scheduler;

import java.text.SimpleDateFormat;
import java.util.Timer;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class ExecuteTimer implements ServletContextListener {

	@Override
	public void contextDestroyed(ServletContextEvent arg0) {}

	@Override
	public void contextInitialized(ServletContextEvent arg0) {		       
//	      try {
//	    	  
//	    	  //comment all lines before start the application because it will start sending mail if you don't comment.
////	    	  
//	    	  Timer t=new Timer();	 
//	    	  
//	    	  t.scheduleAtFixedRate(new EmailScheduler(), 1000,10000);
//		      t.scheduleAtFixedRate(new Cron_Job(), 1000, 10000);
//		      
//		      long delay = 1000L;
//		      t.schedule(new AccountantApproval(), delay, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//		      //scheduler for sales
//		      t.schedule(new SalesDeliveryNotificationScheduler(), delay, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//			  t.schedule(new ConsultingService(), delay, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//			  t.schedule(new ClientPastDuePaymentSecheduler(), delay, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//		      t.schedule(new ClientUpcomingDuePaymentSecheduler(), delay, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//			  t.schedule(new DocumentDailyNotification(), delay,TimeUnit.MILLISECONDS.convert(4,TimeUnit.HOURS));
//    	  	  t.schedule(new PurchaseOrderReminder(), 1000L, TimeUnit.MILLISECONDS.convert(1, TimeUnit.DAYS));
//	          t.scheduleAtFixedRate(new DocumentWeeklyNotification(), new SimpleDateFormat("yyyy-MM-dd").parse("2024-10-13"), TimeUnit.MILLISECONDS.convert(7, TimeUnit.DAYS));
//			  t.scheduleAtFixedRate(new SalesWeeklyReport(), new SimpleDateFormat("yyyy-MM-dd").parse("2024-10-13"), TimeUnit.MILLISECONDS.convert(7, TimeUnit.DAYS));
//	    	  t.scheduleAtFixedRate(new SalesMonthlyReport(), new SimpleDateFormat("yyyy-MM-dd").parse("2024-11-01"), TimeUnit.MILLISECONDS.convert(31, TimeUnit.DAYS));
//		  		
//	      } catch (Exception e) {
//			e.printStackTrace();
//		}
//	      System.out.println(TimeUnit.MILLISECONDS.convert(7, TimeUnit.DAYS));
	     
	}

}
