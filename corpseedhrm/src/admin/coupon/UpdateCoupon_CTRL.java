package admin.coupon;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class UpdateCoupon_CTRL extends HttpServlet {

	private static final long serialVersionUID = -1854290850255848688L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			String token=request.getParameter("token").trim();
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));
			String newtoken=properties.getProperty("corpseed_token");
			
			if(token.equals(newtoken)) {
				
			String uuid=request.getParameter("uuid").trim();
			String title=request.getParameter("title").trim();
			String value=request.getParameter("value").trim();
			String type=request.getParameter("type").trim();
			String startDate=request.getParameter("startDate").trim();
			String endDate=request.getParameter("endDate").trim();
			String displayStatus=request.getParameter("displayStatus").trim();
			String addedByUUID=request.getParameter("addedByUUID").trim();
			String postDate=request.getParameter("postDate").trim();
			String modifyDate=request.getParameter("modifyDate").trim();
			String maximumDiscount=request.getParameter("maximumDiscount").trim();
			String serviceType=request.getParameter("serviceType").trim();
			String prodList=request.getParameter("services");
			String services[]=prodList.split(",");
//			if(serviceType.equals("selected")) {
//				for (String string : services) {
//					System.out.println("services=="+string);
//				}
//			}
			
//			System.out.println("uuid=="+uuid+"/"+title+"/"+value+"/"+type+"/"+startDate+"/"+endDate+"/"+displayStatus+"/"+addedByUUID+"/"
//					+postDate+"/"+modifyDate+"/"+maximumDiscount+"/"+serviceType);
			
			//checking coupon exist or not
			boolean flag=Coupon_ACT.isCouponExist(uuid, token);
			if(flag) {
				boolean updateCoupon = Coupon_ACT.updateCoupon(uuid,title,value,type,startDate,endDate,displayStatus,addedByUUID,modifyDate,maximumDiscount,token,serviceType);
				if(updateCoupon) {
					if(serviceType.equals("selected")) {
						Coupon_ACT.removeAllCouponServices(uuid);
						Coupon_ACT.saveCouponServices(uuid,services,token);
					}else {
						Coupon_ACT.removeAllCouponServices(uuid);
					}
				}
			}else { 
				boolean saveCoupon = Coupon_ACT.saveCoupon(uuid,title,value,type,startDate,endDate,displayStatus,addedByUUID,postDate,modifyDate,maximumDiscount,token,serviceType,"1");
				if(saveCoupon&&serviceType.equals("selected")) {
					Coupon_ACT.saveCouponServices(uuid,services,token);
				}
			}
			response.setStatus(200);
			}else {
				response.setStatus(400);
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}