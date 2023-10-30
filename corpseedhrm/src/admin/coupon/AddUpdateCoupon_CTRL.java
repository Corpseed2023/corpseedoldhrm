package admin.coupon;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.RandomStringUtils;

import commons.DateUtil;

public class AddUpdateCoupon_CTRL extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		try {
			HttpSession session=request.getSession();
			String actionType=request.getParameter("actionType");
			if(actionType!=null)actionType=actionType.trim();
			
			String couponTitle=request.getParameter("couponTitle");	
			if(couponTitle!=null)couponTitle=couponTitle.trim();
			
			String couponValue=request.getParameter("couponValue");
			if(couponValue!=null)couponValue=couponValue.trim();
			
			String couponType=request.getParameter("couponType");
			if(couponType!=null)couponType=couponType.trim();
			String maxDiscount="0";
			if(couponType.equals("percentage"))
			maxDiscount=request.getParameter("maxDiscount");
						
			String serviceType=request.getParameter("serviceType");
			if(serviceType!=null)serviceType=serviceType.trim();
			String services[]=null;
			if(serviceType.equals("selected"))	
				services=request.getParameterValues("services");
						
			String startDate=request.getParameter("startDate");
			if(startDate!=null)startDate=startDate.trim();
			String endDate=request.getParameter("endDate");
			if(endDate!=null)endDate=endDate.trim();
			String displayststus=request.getParameter("displayststus");
			if(displayststus!=null)displayststus=displayststus.trim();
			String token = (String)session.getAttribute("uavalidtokenno");
			String today=DateUtil.getCurrentDateIndianFormat1();
			String loginuaid = (String)session.getAttribute("loginuaid");
			
			if(actionType.equals("add")) {
				
				String uuid=RandomStringUtils.random(40,true,true);
				//saving coupon
				boolean saveCoupon = Coupon_ACT.saveCoupon(uuid, couponTitle, couponValue, couponType, startDate, endDate, displayststus, loginuaid, today, today, maxDiscount, token, serviceType,"2");
				if(saveCoupon&&serviceType.equals("selected")) {
					Coupon_ACT.saveCouponServices(uuid,services,token);
				}
				
			}else if(actionType.equals("update")) {
				String uuid=request.getParameter("couponUuid");
				boolean updateCoupon=Coupon_ACT.updateCoupon(uuid, couponTitle, couponValue, couponType, startDate, endDate, displayststus, loginuaid, today, maxDiscount, token, serviceType);
				if(updateCoupon) {
					if(serviceType.equals("selected")) {
						Coupon_ACT.removeAllCouponServices(uuid);
						Coupon_ACT.saveCouponServices(uuid,services,token);
					}else {
						Coupon_ACT.removeAllCouponServices(uuid);
					}
				}
			}
			RequestDispatcher rd=request.getRequestDispatcher("/coupon/manage_coupon.jsp");
			rd.forward(request, response);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
	}
}