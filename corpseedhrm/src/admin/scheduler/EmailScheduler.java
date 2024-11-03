package admin.scheduler;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.TimerTask;

import admin.enquiry.Enquiry_ACT;
import cron_job.cron_job_ACT;

public class EmailScheduler extends TimerTask {
	
	@Override
	public void run() {
		String token="CP27102021ITES1";
	    String [][] emails=Enquiry_ACT.getAllPendingEmails();
		if(emails!=null&&emails.length>0) {
			for(int i=0;i<emails.length;i++) {
				try {
					String post_param="to="+emails[i][0]+"&cc="+emails[i][1]+"&subject="+emails[i][2]+"&message="+URLEncoder.encode(emails[i][3], StandardCharsets.UTF_8.toString())+"&token="+token;
					String url="https://www.corpseed.com/api/email/send";
					int sendPost = cron_job_ACT.sendPost(url, post_param);	
//					System.out.println("sendPost=="+sendPost);
					Thread.sleep(10000);
					
//					int sendPost=200;
					
					if(sendPost==200)
					Enquiry_ACT.updateEmailScheduler(emails[i][4],1);
				}catch(Exception e) {e.printStackTrace();}
			}
			//removing all emails from scheduler table
//			Enquiry_ACT.removeSendedEmail(token);
		}
	}


}



