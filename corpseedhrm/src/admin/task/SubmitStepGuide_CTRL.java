package admin.task;

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

import commons.AzureBlob;
import commons.DateUtil;


@SuppressWarnings("serial")
public class SubmitStepGuide_CTRL extends HttpServlet {	
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {

		HttpSession session = request.getSession();
		 PrintWriter pw=response.getWriter();
		
		String uavalidtokenno = (String) session.getAttribute("uavalidtokenno");
//		String loginuID = (String) session.getAttribute("loginuID");		
		String today=DateUtil.getCurrentDateIndianFormat1();
//		String time=DateUtil.getCurrentTime();
		String uaid = (String) session.getAttribute("loginuaid");
				
		boolean flag=false;
		try {
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String docpath=properties.getProperty("path")+"documents";
			String azure_key=properties.getProperty("azure_key");
			String azure_container=properties.getProperty("azure_container");
		MultipartRequest m=new MultipartRequest(request,docpath,1024*1024*50);		
		
		int count=Integer.parseInt(m.getParameter("count"));
		String productKey=m.getParameter("product_key");
		String milestone=m.getParameter("milestone");
		String jurisdiction=m.getParameter("jurisdiction");
		int index=milestone.indexOf('#');
		String milestoneId=milestone.substring(0,index);
		String milestoneName=milestone.substring((index+1),milestone.length());
		for(int i=1;i<=count;i++) {
			File file=m.getFile("attachment"+i);
			String imgname="NA";	
			if(file!=null){
				imgname=file.getName();
				file = new File(docpath+File.separator+imgname);
				String key =RandomStringUtils.random(20, true, true);
				imgname=imgname.replaceAll("\\s", "-");
				imgname=key+"_"+imgname;
				File newFile = new File(docpath+File.separator+imgname);
				file.renameTo(newFile);
				
				BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
		        client.connectionString(azure_key);
		        client.containerName(azure_container);
		        InputStream targetStream = new FileInputStream(newFile);
		        client.blobName(imgname).buildClient().upload(targetStream,newFile.length());
				
				targetStream.close();
				newFile.delete();
				} 
			String contents=m.getParameter("GuideStepContentId"+i);
//			System.out.println("GuideStepId"+i);
			String sgKey=TaskMaster_ACT.isStepGuideExist(milestoneId,i,uavalidtokenno,jurisdiction);
			if(sgKey.equalsIgnoreCase("NA")) {
				String mKey=RandomStringUtils.random(40,true,true);
				flag=TaskMaster_ACT.saveStepGuide(mKey,milestoneId,milestoneName,contents,imgname,today,uavalidtokenno,uaid,i,productKey,jurisdiction);
			}else {
				//updating step guide  
				flag=TaskMaster_ACT.updateStepGuide(sgKey,contents,imgname,uavalidtokenno);
			}
		}
		if(flag)pw.write("pass");
		else pw.write("fail");
		}catch(Exception e) {
			e.printStackTrace();
		}
	}

}