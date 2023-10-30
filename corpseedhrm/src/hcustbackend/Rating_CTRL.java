package hcustbackend;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;


public class Rating_CTRL extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session=request.getSession();
		PrintWriter pw=response.getWriter();
		
		//get token no by session
		String token=(String)session.getAttribute("uavalidtokenno");
		String cluaempid = (String) session.getAttribute("cluaempid");
		
		String salesKey=request.getParameter("salesKey");
		if(salesKey!=null)salesKey=salesKey.trim();
		
		String servceRating=request.getParameter("servceRating");
		if(servceRating!=null)servceRating=servceRating.trim();
		
		String executive=request.getParameter("executive");
		if(executive!=null)executive=executive.trim();
		
		String ratingComment=request.getParameter("ratingComment");
		if(ratingComment!=null)ratingComment=ratingComment.trim();
		
		String clientKey=ClientACT.getClientRefId(cluaempid, token);
		String productKey=ClientACT.getProductKey(salesKey,token);
		
		String service[]=servceRating.split("#");
		String today=DateUtil.getCurrentDateIndianReverseFormat();
		boolean flag=false;
		//saving service rating
		if(service!=null) {
			
			String sRatingKey=ClientACT.getServiceRatingExist(salesKey,productKey,clientKey,token);
			if(sRatingKey==null||sRatingKey.equalsIgnoreCase("NA")) {
				String serviceRatingKey=RandomStringUtils.random(40,true,true);
				flag=ClientACT.saveServiceRating(serviceRatingKey,salesKey,productKey,service[0],ratingComment,today,clientKey,token);
			
			//saving rating about tags
			if(flag&&service.length>1) {
				String about[]=service[1].split(",");
				for (String string : about) {
					if(string!=null&&string.length()>0)
					ClientACT.saveAboutRating("Service",serviceRatingKey,string,today,token,"NA");
				}
				
			}
			//saving executive rating
			String executiveKey=RandomStringUtils.random(40,true,true);
			if(flag) {
				String exec[]=executive.split("#");
				for (String string : exec) {
					String x[]=string.split("@");
					String x1[]=x[0].split("-");
					flag=ClientACT.saveExecutiveRating(executiveKey,x1[0],x1[1],today,token,serviceRatingKey);
					//saving rating about executive tags
					if(flag&&x.length>1) {
						String x3[]=x[1].split(",");
						for (String string2 : x3) {
							ClientACT.saveAboutRating("Executive",executiveKey,string2,today,token,x1[0]);
						}
					}
				}
			}
			}else {
				//removing previous data
				ClientACT.removeAboutRating(sRatingKey,token);
				String exeRatingKey=ClientACT.getExecutiveUuid(sRatingKey,token);
				//removing previous data
				if(exeRatingKey!=null&&!exeRatingKey.equalsIgnoreCase("NA")&&exeRatingKey.length()>0)
				ClientACT.removeAboutRating(exeRatingKey,token);
				//updating service rating
				flag=ClientACT.updateServiceRating(sRatingKey,service[0],ratingComment,token);
				
				//updating rating about tags
				if(flag&&service.length>1) {					
					String about[]=service[1].split(",");
					for (String string : about) {
						if(string!=null&&string.length()>0) {							
							ClientACT.saveAboutRating("Service",sRatingKey,string,today,token,"NA");
						}
						
					}
					
				}
				//updating service executive rating
				if(flag) {		
//					System.out.println(executive);
					String exec[]=executive.split("#");
					for (String string : exec) {
						String x[]=string.split("@");
						String x1[]=x[0].split("-");						
						String exRatingKey=ClientACT.getExecutiveKey(x1[0],sRatingKey,token);
//						System.out.println("exRatingKey="+exRatingKey+"/x1[1]="+x1[1]);
						flag=ClientACT.updateExecutiveRating(exRatingKey,x1[0],x1[1],token);
						
						//saving rating about executive tags
						if(flag&&x.length>1) {
							String x3[]=x[1].split(",");
							for (String string2 : x3) {								
								flag=ClientACT.saveAboutRating("Executive",exRatingKey,string2,today,token,x1[0]);
							}							
						}
					}
				}
			}
			
			
		}	
		if(flag)
			pw.write("pass");
		else
			pw.write("fail");
	}

}
