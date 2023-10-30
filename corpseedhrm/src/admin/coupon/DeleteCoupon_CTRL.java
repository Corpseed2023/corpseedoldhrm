package admin.coupon;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@SuppressWarnings("serial")
public class DeleteCoupon_CTRL extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			String token=request.getParameter("token");
			Properties properties = new Properties();
			properties.load(getServletContext().getResourceAsStream("/staticresources/properties"));			
			String crmToken=properties.getProperty("corpseed_token");
			
			if(token.equals(crmToken)) {
				String uuid=request.getParameter("uuid");
				if(uuid!=null)uuid=uuid.trim();
				
				//checking coupon exist or not
				boolean flag=Coupon_ACT.isCouponExist(uuid, token);
				if(flag) {
					Coupon_ACT.deleteCoupon(uuid,token); 
					Coupon_ACT.removeAllCouponServices(uuid);
					response.setStatus(200);
				}else {
					response.setStatus(400);
				}
			}
		}
		catch (Exception e) {
			e.printStackTrace();
		}

	}
}