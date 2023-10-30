package admin.scheduler;

import java.util.TimerTask;

import org.apache.commons.lang.RandomStringUtils;

import admin.task.TaskMaster_ACT;
import commons.DateUtil;

public class DocumentDailyNotification extends TimerTask {
	
	@Override
	public void run() {
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		String time=DateUtil.getCurrentTime24Hours();
//		System.out.println(today+"\n"+time);
		
		//fetching all expired sales and update document status expired and send notification to assignee
		String sales[][]=TaskMaster_ACT.fetchDocumentExpired(today,time);
		if(sales!=null&&sales.length>0) {
			for(int i=0;i<sales.length;i++) {				
				//updating sales expired
				boolean updateFlag=TaskMaster_ACT.updateSalesDocumentStatus(sales[i][0], "3", sales[i][6]);
				if(updateFlag) {
					String teamLeaderUid=TaskMaster_ACT.getTeamLeaderId(sales[i][7], sales[i][6]);
					if(!teamLeaderUid.equalsIgnoreCase("NA")) {
						String nKey=RandomStringUtils.random(40,true,true);
						String message="<span class='text-info'>"+sales[i][1]+" : "+sales[i][3]+"</span> is <b class='text-danger'>expired</b>, Do needful.";
						TaskMaster_ACT.addNotification(nKey,today,teamLeaderUid,"2","document-collection.html?invoice="+sales[i][2],message,sales[i][6],"NA","fas fa-file-powerpoint text-danger");
					}
					//adding for sold person
					String userNKey=RandomStringUtils.random(40,true,true);
					String userMessage="<span class='text-info'>"+sales[i][1]+" : "+sales[i][3]+"</span> is expired, Do needful.";
					TaskMaster_ACT.addNotification(userNKey,today,sales[i][4],"2","document-collection.html?invoice="+sales[i][2],userMessage,sales[i][6],"NA","fas fa-file-powerpoint text-danger");
				}
			}
		}
	}
	
	
}
