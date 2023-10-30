package cron_job;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class RatingUpdaterCTRL extends HttpServlet {

	private static final long serialVersionUID = -703116992564658557L;
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		try {	
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String token=properties.getProperty("corpseed_token");
			String domain=properties.getProperty("corpseed_domain");
			String productNo=req.getParameter("productNo");
			String defaultUser=req.getParameter("user");
			String defaultValue=req.getParameter("rating");
			String productKey="NA";
			if(productNo!=null&&productNo.length()>0&&!productNo.equalsIgnoreCase("NA")) {
				productKey=cron_job_ACT.getProductKey(productNo,token);
				
				String totalRating=cron_job_ACT.getTotalRating(productKey,token,defaultUser,defaultValue);
				
				if(totalRating.length()>0) {
					String post_param="productNo="+productNo+"&totalRating="+totalRating;
					String url=domain+"rating/service";
					cron_job_ACT.sendPost(url, post_param);						
				}
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
}
