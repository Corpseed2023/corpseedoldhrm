package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.azure.storage.blob.BlobClientBuilder;

import commons.AzureBlob;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;


public class GetChatByPageCTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			JSONArray jsonArr = new JSONArray();
			JSONObject json=new JSONObject();
			PrintWriter out=response.getWriter();		
			
			HttpSession session = request.getSession(); 
			String token = (String)session.getAttribute("uavalidtokenno");
			
			String salesKey=request.getParameter("salesKey").trim();
			String clientKey=request.getParameter("clientKey").trim();
			int pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
//			System.out.println("pageNumber=="+pageNumber);
				String chat[][]=ClientACT.getChat(salesKey,clientKey,pageNumber,token);
				if(chat!=null&&chat.length>0) {	
					Properties properties = new Properties();
					properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
					String azure_key=properties.getProperty("azure_key");
					String azure_container=properties.getProperty("azure_container");
					BlobClientBuilder client=AzureBlob.getBlobClient(azure_key, azure_container);
					for(int i=0;i<chat.length;i++) {
						json.put("key",chat[i][0]);		
						json.put("milestoneKey",chat[i][1]);
						json.put("milestoneName",chat[i][2]);
						json.put("dynamicForm",chat[i][3]);
						json.put("content",chat[i][4]);
						json.put("fileName",chat[i][5]);
						json.put("date",chat[i][6]);
						json.put("time",chat[i][7]);
						json.put("submitStatus",chat[i][8]);
						json.put("addedbyUid",chat[i][9]);
						json.put("addedbyName",chat[i][10]);
						json.put("formStatus",chat[i][11]);
						json.put("formName",chat[i][12]);
						json.put("unread",chat[i][13]);
						
						String fileName=chat[i][5];
						String extension="";
						String size="";
						if(fileName!=null&&!fileName.equalsIgnoreCase("NA")&&fileName.length()>0){
						
					boolean fileExist=client.blobName(fileName).buildClient().exists();
					long bytes=0;
					if(fileExist){
						bytes=client.blobName(fileName).buildClient().getProperties().getBlobSize();
					}			
					long kb=bytes/1024;
					long mb=kb/1024;	
					
					if(mb>=1)size=mb+" MB";
					else if(kb>=1) size=kb+" KB";
					else size=bytes+" bytes";
					int index=chat[i][5].lastIndexOf(".");
					extension=chat[i][5].substring(index);
						}
						json.put("extension",extension);
						json.put("size",size);
						
						jsonArr.add(json);
					}
					out.println(jsonArr);
				}				
			
		}catch (Exception e) {
				e.printStackTrace();
		}
	}

}
