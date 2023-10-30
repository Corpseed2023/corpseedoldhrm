package commons;

import java.util.Date;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class EmailSender {

	public static boolean sendEmail(String destmailid,String cc,String subject,String message) {
		boolean flag=false;
		try {		
		//Declare recipient's & sender's e-mail id.
	      String sendrmailid = "updates@corpseed.com";	  
	     //Mention user name and password as per your configuration
	      final String uname = "updates@corpseed.com";
	      final String pwd = "updates@418K#";
	      //We are using relay.jangosmtp.net for sending emails
	      String smtphost = "smtp.gmail.com";
	     //Set properties and their values
	      Properties propvls = new Properties();
	      propvls.put("mail.smtp.auth", "true");
	      propvls.put("mail.smtp.starttls.enable", "true");
	      propvls.put("mail.debug", "true");
	      propvls.put("mail.smtp.host", smtphost);
	      propvls.put("mail.smtp.port", "587");
	      
	      //Create a Session object & authenticate uid and pwd
	      Session sessionobj = Session.getInstance(propvls,
	         new javax.mail.Authenticator() {
	            protected PasswordAuthentication getPasswordAuthentication() {
	               return new PasswordAuthentication(uname, pwd);
		   }
	         });

	      try {
		   //Create MimeMessage object & set values
		   Message messageobj = new MimeMessage(sessionobj);
		   messageobj.setFrom(new InternetAddress(sendrmailid));
		   messageobj.setRecipients(Message.RecipientType.TO,InternetAddress.parse(destmailid));
		System.out.println("cc="+cc+"/"+destmailid);
		if(!cc.equalsIgnoreCase("empty")) {   
		if(!cc.equals("NA")&&cc.contains(",")) {
			System.out.println("going to add cc");
		   String x[]=cc.split(",");
		      InternetAddress[] ccAddress = new InternetAddress[x.length];
		   // To get the array of ccaddresses
	          for( int i = 0; i < x.length; i++ ) {
	        	  System.out.println("CC="+x[i]);
	              ccAddress[i] = new InternetAddress(x[i]);
	          }
		   // Set cc: header field of the header.
           for( int i = 0; i < ccAddress.length; i++) {
        	   System.out.println("CC1="+ccAddress[i]);
        	   messageobj.addRecipient(Message.RecipientType.CC, ccAddress[i]);
           }
           }else if(!cc.equals("NA")) {
        	   System.out.println(cc);
        	   System.out.println("going to add cc1");
        	   messageobj.setRecipients(Message.RecipientType.CC, InternetAddress.parse(cc));  
           }}
		   messageobj.setSubject(subject);
		   messageobj.setContent(message, "text/html");
		   messageobj.setSentDate(new Date());
		  //Now send the message
		   Transport.send(messageobj);
		   flag=true;
		   System.out.println("Your email sent successfully....");
	      } catch (MessagingException exp) {
	         throw new RuntimeException(exp);
	      }
		
	}catch(Exception e) {e.printStackTrace();}
		return flag;
	}
}
