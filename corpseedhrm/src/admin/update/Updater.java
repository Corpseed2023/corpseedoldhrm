package admin.update;

import org.apache.commons.lang.RandomStringUtils;

import admin.enquiry.Enquiry_ACT;
import admin.master.Usermaster_ACT;
import client_master.Clientmaster_ACT;
import commons.DateUtil;

public class Updater {


	public static void main(String[] args) {
		//updating user account company name ITSWS to Corpeed
		/*System.out.println("Company update started..");
		Updater_ACT.updateCompany();
		System.out.println("Company update completed..");

		System.out.println("Updating client to Super User : started..");
		Updater_ACT.convertToSuperUser();
		System.out.println("Updating client to Super User : completed..");
		
		System.out.println("Updating client's Super User : started..");
		String users[][]=Updater_ACT.findUserByRole();
		for(int i=0;i<users.length;i++)
		Updater_ACT.updateClientsSuperUser(users[i][0],users[i][1]);
		System.out.println("Updating client's Super User : completed..");
						
		System.out.println("Updating main contact super user : started..");
		for(int i=0;i<users.length;i++)
			Updater_ACT.updateMainContact(users[i][0],users[i][2],users[i][3]);
		System.out.println("Updating main contact super user : completed..");
		
		
		System.out.println("Updating contact id into super user : started..");
		String contacts[][]=Updater_ACT.findAllContacts();
		for(int i=0;i<contacts.length;i++)
			Updater_ACT.updateUserContactId(contacts[i][0],contacts[i][1]);
		System.out.println("Updating contact id into super user : completed..");
		
		String contacts[][]=Updater_ACT.findAllContacts();
		System.out.println("Updating sales contact with super user : started..");
		for(int i=0;i<contacts.length;i++)
			Updater_ACT.updateSalesContactId(contacts[i][1],contacts[i][2]);
		System.out.println("Updating sales contact with super user : completed..");
		
		System.out.println("Updating delivery person : started..");
		Updater_ACT.updateDeliveryPerson();
		System.out.println("Updating delivery person : completed..");
		
		
		//create super login who have estimate only
		System.out.println("ADD SUPER USER : started..");
		String[][] clients = Updater_ACT.fetchAllEstimateClient();
		if(clients!=null&&clients.length>0)
			for(int i=0;i<clients.length;i++) {
				String uapassword=RandomStringUtils.random(8,true,true);
				String loginkey=RandomStringUtils.random(40,true,true);
				String uacompany= "Corpseed ITES Pvt. Ltd.";
				String uaaip ="0.0.0";
				String uaabname = "NA";
				int super_user_id=0;
				int contact_id=0;
				String clientno=DateUtil.getCurrentDateIndianFormat1().replace("-", "")+System.currentTimeMillis();
				String username="";
				String contact[][]=Updater_ACT.findContactByKey(clients[i][1], "CP27102021ITES1");
				if(contact!=null&&contact.length>0) {
//					System.out.println("length=="+contact[0][3].length()+"\t"+contact[0][3].substring(contact[0][3].length()-10));
					if(contact[0][3].length()>10)username=contact[0][3].substring(contact[0][3].length()-10);
					else username=contact[0][3];
				}else username=RandomStringUtils.random(10, true, true);
				boolean clientflag=Usermaster_ACT.isClientsLoginId(username,"CP27102021ITES1");
				
				if(!clientflag&&contact!=null&&contact.length>0) {
					boolean flag=Usermaster_ACT.saveUserDetail("CP27102021ITES1",username,uapassword,clients[i][2],contact[0][3],contact[0][2],"NA","Corpseed",uaaip,uaabname,"Client",clientno, uacompany,loginkey,"NA","SUPER_USER","0.0.0","2",super_user_id,contact_id);
					if(flag) {
						int uaid=Usermaster_ACT.findUserUaidByMobile(username, "CP27102021ITES1");
						Updater_ACT.updateClientsSuperUser(uaid, clients[i][0]);
						if(contact!=null&&contact.length>0) {
							for(int j=0;j<contact.length;j++) {
								Updater_ACT.updateMainContactSuperUser(uaid, contact[j][4]);
							}
						}
					}
						
				}
			}
		
		System.out.println("ADD SUPER USER : COMPLETED..");
		
		
		
		System.out.println("ADD SUPER USER : started..");
		String[][] clients = Updater_ACT.fetchAllClientWithoutUser();
		if(clients!=null&&clients.length>0)
			for(int i=0;i<clients.length;i++) {
				String uapassword=RandomStringUtils.random(8,true,true);
				String loginkey=RandomStringUtils.random(40,true,true);
				String uacompany= "Corpseed ITES Pvt. Ltd.";
				String uaaip ="0.0.0";
				String uaabname = "NA";
				int super_user_id=0;
				int contact_id=0;
				String clientno=DateUtil.getCurrentDateIndianFormat1().replace("-", "")+System.currentTimeMillis();
				String username="";
				String contact[][]=Updater_ACT.findContactByKey(clients[i][1], "CP27102021ITES1");
				if(contact!=null&&contact.length>0) {
//					System.out.println("length=="+contact[0][3].length()+"\t"+contact[0][3].substring(contact[0][3].length()-10));
					if(contact[0][3].length()>10)username=contact[0][3].substring(contact[0][3].length()-10);
					else username=contact[0][3];
				}else username=RandomStringUtils.random(10, true, true);
				boolean clientflag=Usermaster_ACT.isClientsLoginId(username,"CP27102021ITES1");
				
				if(!clientflag&&contact!=null&&contact.length>0) {
					boolean flag=Usermaster_ACT.saveUserDetail("CP27102021ITES1",username,uapassword,clients[i][2],contact[0][3],contact[0][2],"NA","Corpseed",uaaip,uaabname,"Client",clientno, uacompany,loginkey,"NA","SUPER_USER","0.0.0","2",super_user_id,contact_id);
					if(flag) {
						int uaid=Usermaster_ACT.findUserUaidByMobile(username, "CP27102021ITES1");
						Updater_ACT.updateClientsSuperUser(uaid, clients[i][0]);
						if(contact!=null&&contact.length>0) {
							for(int j=0;j<contact.length;j++) {
								Updater_ACT.updateMainContactSuperUser(uaid, contact[j][4]);
							}
						}
					}
						
				}
			}
		
		System.out.println("ADD SUPER USER : COMPLETED..");
		*/
	}

}
